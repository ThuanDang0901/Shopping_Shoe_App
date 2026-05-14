import 'package:application_shoe_ecommerce/module/data/models/shoe_model.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shoerepositoryimpl implements ShoeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Shoe>> getFeaturedShoes() async {
    try {
      final snapshot = await _firestore
          .collection('shoes')
          .where('isActive', isEqualTo: true)
          .orderBy('soldCount', descending: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        return ShoeModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách sản phẩm: $e");
      throw Exception("Lỗi khi lấy danh sách sản phẩm: $e");
    }
  }
}
