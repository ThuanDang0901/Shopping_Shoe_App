import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';

class OrderModel {
  static Map<String, dynamic> toMap(OrderEntity order) {
    return {
      'userId': order.userId,
      'userName': order.userName,
      'shippingAddress': order.shippingAddress,
      'paymentMethod': order.paymentMethod,
      'subtotal': order.subtotal,
      'shippingFee': order.shippingFee,
      'tax': order.tax,
      'total': order.total,
      'createdAt': Timestamp.fromDate(order.createdAt),
      'status': order.status,
      'items': order.items
          .map(
            (item) => {
              'shoeId': item.shoe.id,
              'name': item.shoe.name,
              'price': item.shoe.price,
              'image': item.shoe.image,
              'quantity': item.quantity,
              'selectedColor': item.selectedColor,
              'selectedSize': item.selectedSize,
            },
          )
          .toList(),
    };
  }
}
