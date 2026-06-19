import 'package:application_shoe_ecommerce/module/domain/repositories/OrderRepository.dart';

class GetTotalOrdersCountUseCase {
  final OrderRepository repository;
  GetTotalOrdersCountUseCase(this.repository);

  Stream<int> execute() {
    return repository.getTotalOrdersCountStream();
  }
}
