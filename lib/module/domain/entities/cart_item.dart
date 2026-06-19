import 'package:equatable/equatable.dart';
import 'shoe.dart';

class CartItem extends Equatable {
  final String id;
  final Shoe shoe;
  final String variantId;
  final int selectedSize;
  final String selectedColor;
  final int quantity;

  const CartItem({
    required this.id,
    required this.shoe,
    required this.variantId,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
  });

  CartItem copyWith({
    String? id,
    Shoe? shoe,
    String? variantId,
    int? selectedSize,
    String? selectedColor,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      shoe: shoe ?? this.shoe,
      variantId: variantId ?? this.variantId,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
    id,
    shoe,
    variantId,
    selectedSize,
    selectedColor,
    quantity,
  ];
}
