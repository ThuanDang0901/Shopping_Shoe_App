import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';

abstract class ShoeRepository {
  Future<List<Shoe>> getFeaturedShoes();
}
