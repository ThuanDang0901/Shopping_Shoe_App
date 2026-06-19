import 'package:application_shoe_ecommerce/module/domain/entities/cart_item.dart';

class OrderEntity {
  final String? id;
  final String userId;
  final String userName;
  final String shippingAddress;
  final String paymentMethod;
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double total;
  final DateTime createdAt;
  final String status;

  OrderEntity({
    this.id,
    required this.userId,
    required this.userName,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.items,
    required this.subtotal,
    this.shippingFee = 5.0,
    this.tax = 15.20,
    required this.total,
    required this.createdAt,
    this.status = 'pending',
  });
}
