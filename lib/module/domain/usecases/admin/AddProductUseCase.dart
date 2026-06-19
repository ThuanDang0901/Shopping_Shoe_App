import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart';

class AddProductUseCase {
  final ShoeRepository repository;

  AddProductUseCase(this.repository);

  Future<void> execute(Shoe shoe) async {
    return await repository.addProduct(shoe);
  }
}
