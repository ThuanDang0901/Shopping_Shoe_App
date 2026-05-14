import 'package:application_shoe_ecommerce/module/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategory();
}
