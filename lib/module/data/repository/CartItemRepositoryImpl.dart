import 'package:application_shoe_ecommerce/module/data/models/shoe_model.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/cart_item.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/CartRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartRepositoryImpl implements CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<CartItem>> getCartShoes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final shoe = ShoeModel.fromMap(data['shoe'], data['shoeId']);

        return CartItem(
          id: doc.id,
          shoe: shoe,
          selectedColor: data['selectedColor'] ?? '',
          selectedSize: data['selectedSize'] ?? 0,
          quantity: data['quantity'] ?? 1,
        );
      }).toList();
    } catch (e) {
      throw Exception("Lỗi lấy giỏ hàng: $e");
    }
  }

  @override
  Future<void> addToCart(String userId, CartItem cartItem) async {
    try {
      final cartRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cart');

      // Tìm xem sản phẩm cùng màu, cùng size đã tồn tại chưa
      final existingQuery = await cartRef
          .where('shoeId', isEqualTo: cartItem.shoe.id)
          .where('selectedColor', isEqualTo: cartItem.selectedColor)
          .where('selectedSize', isEqualTo: cartItem.selectedSize)
          .limit(1)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        final docId = existingQuery.docs.first.id;
        int currentQty = existingQuery.docs.first.data()['quantity'] ?? 1;
        await cartRef.doc(docId).update({
          'quantity': currentQty + cartItem.quantity,
        });
      } else {
        // Thêm mới sản phẩm vào giỏ hàng
        await cartRef.add({
          'shoeId': cartItem.shoe.id,
          'selectedColor': cartItem.selectedColor,
          'selectedSize': cartItem.selectedSize,
          'quantity': cartItem.quantity,
          'shoe': {
            'name': cartItem.shoe.name,
            'sku': cartItem.shoe.sku,
            'description': cartItem.shoe.description,
            'price': cartItem.shoe.price,
            'image': cartItem.shoe.image,
            'stockQuantity': cartItem.shoe.stockQuantity,
            'soldCount': cartItem.shoe.soldCount,
            'category': cartItem.shoe.category,
            'isActive': cartItem.shoe.isActive,
            'colors': cartItem.shoe.colors,
            'sizes': cartItem.shoe.sizes,
          },
        });
      }
    } catch (e) {
      throw Exception("Không thể thêm vào giỏ hàng: $e");
    }
  }

  @override
  Future<void> removeFromCart(String userId, String cartItemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();
    } catch (e) {
      throw Exception("Không thể xóa khỏi giỏ hàng: $e");
    }
  }

  @override
  Future<void> updateQuantity(
    String userId,
    String cartItemId,
    int quantity,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .update({'quantity': quantity});
    } catch (e) {
      throw Exception("Không thể cập nhật số lượng: $e");
    }
  }
}
