import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart';

class SearchShoesUseCase {
  final ShoeRepository repository;

  SearchShoesUseCase(this.repository);

  Future<List<Shoe>> execute(String query) async {
    return await repository.searchShoes(query);
  }
}
