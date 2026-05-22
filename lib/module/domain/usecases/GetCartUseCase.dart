import 'package:application_shoe_ecommerce/module/domain/entities/cart_item.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/CartRepository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<List<CartItem>> execute(String userId) async {
    return await repository.getCartShoes(userId);
  }
}