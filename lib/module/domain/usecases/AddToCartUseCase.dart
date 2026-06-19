import 'package:application_shoe_ecommerce/module/domain/entities/cart_item.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/CartRepository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> execute(String userId, CartItem cartItem) async {
    return await repository.addToCart(userId, cartItem);
  }
}
