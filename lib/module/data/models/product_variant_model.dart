import 'package:application_shoe_ecommerce/module/domain/entities/product_variant.dart';

class ProductVariantModel extends ProductVariant {
  const ProductVariantModel({
    required super.id,
    required super.size,
    required super.color,
    required super.stockQuantity,
    required super.price,
  });

  factory ProductVariantModel.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) {
    return ProductVariantModel(
      id: id,
      size: json['size'] as int,
      color: json['color'] as String,
      stockQuantity: json['stockQuantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'size': size,
      'color': color,
      'stockQuantity': stockQuantity,
      'price': price,
    };
  }
}
