import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';

class ShoeModel extends Shoe {
  ShoeModel({
    required super.id,
    required super.name,
    required super.price,
    required super.image,
    required super.soldCount,
    required super.sku,
    required super.description,
    required super.stockQuantity,
    required super.category,
    required super.isActive,
  });

  factory ShoeModel.fromMap(Map<String, dynamic> map, String docId) {
    return ShoeModel(
      id: docId,
      name: map['name'] ?? '',
      sku: map['sku'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      stockQuantity: map['stockQuantity'] ?? 0,
      soldCount: map['soldCount'] ?? 0,
      category: map['category'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }
}
