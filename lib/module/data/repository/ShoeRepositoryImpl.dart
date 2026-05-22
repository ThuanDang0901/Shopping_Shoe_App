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

  @override
  Future<void> addToWishlist(String userId, Shoe shoe) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(shoe.id)
          .set({
            'name': shoe.name,
            'sku': shoe.sku,
            'description': shoe.description,
            'price': shoe.price,
            'image': shoe.image,
            'stockQuantity': shoe.stockQuantity,
            'soldCount': shoe.soldCount,
            'category': shoe.category,
            'isActive': shoe.isActive,
            'colors': shoe.colors,
            'sizes': shoe.sizes,
          });
    } catch (e) {
      throw Exception("Không thể thêm vào wishlist: $e");
    }
  }

  @override
  Future<List<Shoe>> getWishlistShoes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();

      return snapshot.docs.map((doc) {
        final shoe = ShoeModel.fromMap(doc.data(), doc.id);
        shoe.isFavorite = true;
        return shoe;
      }).toList();
    } catch (e) {
      throw Exception("Lỗi lấy danh sách yêu thích: $e");
    }
  }

  @override
  Future<void> removeFromWishlist(String userId, String shoeId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(shoeId)
          .delete();
    } catch (e) {
      throw Exception("Không thể xóa khỏi wishlist: $e");
    }
  }

  @override
  Future<bool> checkIsFavorite(String userId, String shoeId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(shoeId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Shoe>> searchShoes(String query) async {
    try {
      final snapshot = await _firestore
          .collection('shoes')
          .where('isActive', isEqualTo: true)
          .get();
      final List<Shoe> allShoes = snapshot.docs.map((doc) {
        return ShoeModel.fromMap(doc.data(), doc.id);
      }).toList();

      if (query.trim().isEmpty) {
        return allShoes;
      }

      final String lowercaseQuery = query.toLowerCase().trim();
      return allShoes.where((shoe) {
        final bool matchName = shoe.name.toLowerCase().contains(lowercaseQuery);
        final bool matchCategory = shoe.category.toLowerCase().contains(
          lowercaseQuery,
        );
        return matchName || matchCategory;
      }).toList();
    } catch (e) {
      print("Lỗi khi tìm kiếm sản phẩm: $e");
      throw Exception("Lỗi khi tìm kiếm sản phẩm: $e");
    }
  }
}
