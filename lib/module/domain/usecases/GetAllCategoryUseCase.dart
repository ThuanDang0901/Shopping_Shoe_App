import 'package:application_shoe_ecommerce/module/domain/entities/category.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/CategoryRepository.dart';

class GetAllCategoryUseCase {
  final CategoryRepository repository;
  GetAllCategoryUseCase(this.repository);
  Future<List<Category>> execute() async {
    return await repository.getAllCategory();
  }
}
