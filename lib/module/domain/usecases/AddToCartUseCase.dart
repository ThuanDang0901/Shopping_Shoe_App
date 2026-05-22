import 'package:application_shoe_ecommerce/module/domain/entities/cart_item.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/CartRepository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required Shoe shoe,
    required String selectedColor,
    required int selectedSize,
    required int quantity,
  }) async {
    final cartItem = CartItem(
      id: '',
      shoe: shoe,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      quantity: quantity,
    );

    return await repository.addToCart(userId, cartItem);
  }
}