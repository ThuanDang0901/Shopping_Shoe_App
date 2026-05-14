import 'package:application_shoe_ecommerce/module/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({required super.name, required super.icon});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(name: map['name'] ?? '', icon: map['icon'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'icon': icon};
  }
}
