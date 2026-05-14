import 'package:application_shoe_ecommerce/module/data/models/category_model.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/category.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/CategoryRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categoryrepositoryimpl implements CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Category>> getAllCategory() async {
    try {
      final snapshot = await _firestore.collection('categories').get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Lỗi lấy danh mục: $e");
      return [];
    }
  }
}
