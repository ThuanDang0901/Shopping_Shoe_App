// lib/module/data/models/shoe_model.dart
import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';

class ShoeModel {
  final String id;
  final String name;
  final String sku;
  final String description;
  final double price;
  final String image;
  final int stockQuantity;
  final int soldCount;
  final String category;
  final bool isActive;
  final List<String> colors;
  final List<int> sizes;

  ShoeModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.soldCount,
    required this.sku,
    required this.description,
    required this.stockQuantity,
    required this.category,
    required this.isActive,
    required this.colors,
    required this.sizes,
  });
  // 1. Chuyển đổi từ Map (Firestore Document) -> Model tầng Data
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
      colors: List<String>.from(map['colors'] ?? []),
      sizes: List<int>.from(map['sizes'] ?? []),
    );
  }

  // 2. BỔ SUNG: Chuyển đổi từ Entity tầng Domain -> Model tầng Data
  factory ShoeModel.fromEntity(Shoe shoe) {
    return ShoeModel(
      id: shoe.id,
      name: shoe.name,
      sku: shoe.sku,
      description: shoe.description,
      price: shoe.price,
      image: shoe.image,
      stockQuantity: shoe.stockQuantity,
      soldCount: shoe.soldCount,
      category: shoe.category,
      isActive: shoe.isActive,
      colors: shoe.colors,
      sizes: shoe.sizes,
    );
  }

  // 3. BỔ SUNG: Biến đổi Model thành Map để lưu xuống Firestore (Dùng trong Repository.addProduct)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'image': image,
      'stockQuantity': stockQuantity,
      'soldCount': soldCount,
      'category': category,
      'isActive': isActive,
      'colors': colors,
      'sizes': sizes,
    };
  }

  // 4. Chuyển đổi từ Model tầng Data -> Entity tầng Domain
  Shoe toEntity() {
    return Shoe(
      id: id,
      name: name,
      price: price,
      image: image,
      soldCount: soldCount,
      sku: sku,
      description: description,
      stockQuantity: stockQuantity,
      category: category,
      isActive: isActive,
      colors: colors,
      sizes: sizes,
    );
  }
}
