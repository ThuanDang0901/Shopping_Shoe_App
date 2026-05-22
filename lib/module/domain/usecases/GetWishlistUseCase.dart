import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart';

class GetWishlistUseCase {
  final ShoeRepository repository;
  GetWishlistUseCase(this.repository);

  Future<List<Shoe>> execute(String userId) async {
    return await repository.getWishlistShoes(userId);
  }
}
