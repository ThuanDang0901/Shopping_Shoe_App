import 'package:application_shoe_ecommerce/module/domain/repositories/OrderRepository.dart';

class GetTotalRevenueUseCase {
  final OrderRepository repository;
  GetTotalRevenueUseCase(this.repository);

  Stream<double> execute() {
    return repository.getTotalRevenueStream();
  }
}
