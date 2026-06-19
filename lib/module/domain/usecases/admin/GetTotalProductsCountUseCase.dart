import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart';

class GetTotalProductsCountUseCase {
  final ShoeRepository repository;

  GetTotalProductsCountUseCase(this.repository);

  Future<int> execute() async {
    return await repository.getTotalProductsCount();
  }
}
