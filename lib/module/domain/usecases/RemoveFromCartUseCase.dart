import 'package:application_shoe_ecommerce/module/domain/repositories/CartRepository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<void> execute(String userId, String cartItemId) async {
    return await repository.removeFromCart(userId, cartItemId);
  }
}