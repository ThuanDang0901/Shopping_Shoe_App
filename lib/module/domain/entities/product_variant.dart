import 'package:equatable/equatable.dart';

class ProductVariant extends Equatable {
  final String id;
  final int size;
  final String color;
  final int stockQuantity;
  final double price;

  const ProductVariant({
    required this.id,
    required this.size,
    required this.color,
    required this.stockQuantity,
    required this.price,
  });

  @override
  List<Object?> get props => [id, size, color, stockQuantity, price];
}
