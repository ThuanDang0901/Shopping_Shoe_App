import 'package:application_shoe_ecommerce/module/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartShoes(String userId);
  Future<void> addToCart(String userId, CartItem cartItem);
  Future<void> removeFromCart(String userId, String cartItemId);
  Future<void> updateQuantity(String userId, String cartItemId, int quantity);
}