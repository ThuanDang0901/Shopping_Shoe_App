import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/OrderRepository.dart';

class GetRecentOrdersUseCase {
  final OrderRepository repository;
  GetRecentOrdersUseCase(this.repository);

  Stream<List<OrderEntity>> execute() {
    return repository.getRecentOrdersStream();
  }
}