import 'package:application_shoe_ecommerce/module/data/models/order_model.dart';
import 'package:application_shoe_ecommerce/module/data/models/shoe_model.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/cart_item.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/OrderRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<double> getTotalRevenueStream() {
    return _firestore
        .collection('system_stats')
        .doc('dashboard')
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            return (snapshot.data()?['totalRevenue'] ?? 0.0).toDouble();
          }
          return 0.0;
        });
  }

  @override
  Stream<int> getTotalOrdersCountStream() {
    // Sử dụng collectionGroup để Admin đếm tổng số lượng đơn hàng từ tất cả người dùng
    return _firestore.collectionGroup('orders').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  List<CartItem> _mapCartItems(List<dynamic> itemsMap) {
    return itemsMap.map((item) {
      return CartItem(
        id: item['id'] ?? '',
        shoe: ShoeModel.fromMap(item, item['shoeId'] ?? '').toEntity(),
        variantId: item['variantId'] ?? '',
        selectedColor: item['selectedColor'] ?? '',
        selectedSize: item['selectedSize'] ?? 0,
        quantity: item['quantity'] ?? 1,
      );
    }).toList();
  }

  // Hàm helper mapper từ Document sang Entity
  OrderEntity _mapToOrderEntity(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final List<dynamic> itemsMap = data['items'] ?? [];

    return OrderEntity(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Khách hàng',
      shippingAddress: data['shippingAddress'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      subtotal: (data['subtotal'] ?? 0.0).toDouble(),
      shippingFee: (data['shippingFee'] ?? 0.0).toDouble(),
      tax: (data['tax'] ?? 0.0).toDouble(),
      total: (data['total'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      items: _mapCartItems(itemsMap),
      status: data['status'] ?? 'pending',
    );
  }

  @override
  Stream<List<OrderEntity>> getRecentOrdersStream() {
    return _firestore.collectionGroup('orders').snapshots().map((snapshot) {
      final orders = snapshot.docs
          .map(
            (doc) => _mapToOrderEntity(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders.take(5).toList();
    });
  }

  @override
  Stream<List<OrderEntity>> getAllOrdersStream() {
    return _firestore.collectionGroup('orders').snapshots().map((snapshot) {
      final orders = snapshot.docs
          .map(
            (doc) => _mapToOrderEntity(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    });
  }

  @override
  Stream<List<OrderEntity>> getOrdersByUserIdStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => _mapToOrderEntity(doc)).toList();
        });
  }

  @override
  Future<void> placeOrderWithStock({
    required OrderEntity order,
    required Map<String, int> stockUpdates,
  }) async {
    try {
      print(
        "====== [DEBUG REPO] KHỞI CHẠY TRANSACTION ĐẶT HÀNG (SUB-COLLECTION) ======",
      );

      await _firestore.runTransaction((transaction) async {
        // 1. Kiểm tra kho biến thể (ví dụ tài liệu "#FFFFFF_40") và trừ số lượng tồn kho
        for (var item in order.items) {
          if (item.variantId.isEmpty) {
            throw Exception(
              "Không tìm thấy mã kho (variantId) của sản phẩm ${item.shoe.name}",
            );
          }

          final variantDocRef = _firestore
              .collection('shoes')
              .doc(item.shoe.id)
              .collection('variants')
              .doc(item.variantId);

          final variantSnapshot = await transaction.get(variantDocRef);

          if (!variantSnapshot.exists) {
            throw Exception(
              "Mẫu biến thể kho này không tồn tại trên dữ liệu hệ thống!",
            );
          }

          int currentStock = variantSnapshot['stockQuantity'] ?? 0;

          if (currentStock < item.quantity) {
            throw Exception(
              "Mẫu giày ${item.shoe.name} - Size: ${item.selectedSize} chỉ còn $currentStock đôi, không đủ đáp ứng đơn hàng!",
            );
          }

          transaction.update(variantDocRef, {
            'stockQuantity': currentStock - item.quantity,
          });
        }

        // 2. ✨ ĐÃ THAY ĐỔI: Khởi tạo tài liệu Đơn hàng nằm lồng trong sub-collection orders của User
        final orderRef = _firestore
            .collection('users')
            .doc(order.userId)
            .collection('orders')
            .doc(); // Firestore tự sinh ID ngẫu nhiên cho tài liệu order này

        final orderData = OrderModel.toMap(order);
        orderData['orderId'] = orderRef.id;

        orderData['items'] = order.items
            .map(
              (item) => {
                'id': item.id,
                'shoeId': item.shoe.id,
                'variantId': item.variantId,
                'name': item.shoe.name,
                'sku': item.shoe.sku,
                'price': item.shoe.price,
                'image': item.shoe.image,
                'selectedColor': item.selectedColor,
                'selectedSize': item.selectedSize,
                'quantity': item.quantity,
              },
            )
            .toList();

        transaction.set(orderRef, orderData);

        // 3. Tiến hành dọn dẹp các món đồ đã mua thành công ra khỏi giỏ hàng của User
        final cartRef = _firestore
            .collection('users')
            .doc(order.userId)
            .collection('cart');

        for (var item in order.items) {
          if (item.id.isNotEmpty) {
            transaction.delete(cartRef.doc(item.id));
          }
        }

        // 4. Gia tăng chỉ số thống kê tổng doanh thu hệ thống
        final statsRef = _firestore.collection('system_stats').doc('dashboard');
        transaction.set(statsRef, {
          'totalRevenue': FieldValue.increment(order.total),
          'totalOrders': FieldValue.increment(1),
        }, SetOptions(merge: true));

        print(
          "====== [DEBUG REPO] TRANSACTION ĐẶT HÀNG THÀNH CÔNG MIÊN MÃN ======",
        );
      });
    } catch (e) {
      print("THẤT BẠI QUY TRÌNH TRANSACTION ĐẶT HÀNG: $e");
      throw Exception(e.toString());
    }
  }
}
