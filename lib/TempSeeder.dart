import 'package:cloud_firestore/cloud_firestore.dart';

class TempSeeder {
  static Future<void> seedShoes() async {
    final CollectionReference shoes = FirebaseFirestore.instance.collection(
      'shoes',
    );

    List<Map<String, dynamic>> dummyShoes = [
      {
        "name": "Nike Air Max 270",
        "sku": "SKU_002",
        "description": "Siêu phẩm chạy bộ với đệm Air cực êm.",
        "price": 3000000.0,
        "image": "assets/img/shoe1.png",
        "stockQuantity": 50,
        "soldCount": 120,
        "category": "Nike",
        "isActive": true,
      },
      {
        "name": "Adidas Ultraboost 22",
        "sku": "SKU_003",
        "description": "Hoàn năng lượng tối đa trên mỗi bước chạy.",
        "price": 4200000.0,
        "image": "assets/img/shoe2.png",
        "stockQuantity": 30,
        "soldCount": 85,
        "category": "Adidas",
        "isActive": true,
      },
      {
        "name": "Adidas Ultraboost 22",
        "sku": "SKU_004",
        "description": "Hoàn năng lượng tối đa trên mỗi bước chạy.",
        "price": 4200000.0,
        "image": "assets/img/shoe2.png",
        "stockQuantity": 30,
        "soldCount": 85,
        "category": "Adidas",
        "isActive": true,
      },
      {
        "name": "Adidas Ultraboost 22",
        "sku": "SKU_005",
        "description": "Hoàn năng lượng tối đa trên mỗi bước chạy.",
        "price": 4200000.0,
        "image": "assets/img/shoe2.png",
        "stockQuantity": 30,
        "soldCount": 85,
        "category": "Adidas",
        "isActive": true,
      },
    ];

    for (var shoe in dummyShoes) {
      await shoes.add(shoe);
    }
    print("Đã thêm 10 sản phẩm thành công!");
  }
}
