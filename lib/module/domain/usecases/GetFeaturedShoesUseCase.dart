import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart';

class GetFeaturedShoesUseCase {
  final ShoeRepository repository;

  GetFeaturedShoesUseCase(this.repository);

  Future<List<Shoe>> execute() async {
    return await repository.getFeaturedShoes();
  }
}
