import 'package:application_shoe_ecommerce/module/domain/repositories/CartRepository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<void> execute(String userId, String cartItemId, int quantity) async {
    return await repository.updateQuantity(userId, cartItemId, quantity);
  }
}