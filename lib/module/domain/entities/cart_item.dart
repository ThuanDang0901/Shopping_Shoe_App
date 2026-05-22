import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';

class CartItem {
  final String id;
  final Shoe shoe;
  final String selectedColor;
  final int selectedSize;
  int quantity;

  CartItem({
    required this.id,
    required this.shoe,
    required this.selectedColor,
    required this.selectedSize,
    required this.quantity,
  });
}
