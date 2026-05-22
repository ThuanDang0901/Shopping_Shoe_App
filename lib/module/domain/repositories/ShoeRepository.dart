import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';

abstract class ShoeRepository {
  Future<List<Shoe>> getFeaturedShoes();
  Future<List<Shoe>> getWishlistShoes(String userId);
  Future<void> addToWishlist(String userId, Shoe shoe);
  Future<void> removeFromWishlist(String userId, String shoeId);
  Future<bool> checkIsFavorite(String userId, String shoeId);
  Future<List<Shoe>> searchShoes(String query);
}
