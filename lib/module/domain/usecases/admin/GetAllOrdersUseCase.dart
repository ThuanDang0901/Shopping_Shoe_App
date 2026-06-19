import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/OrderRepository.dart';

class GetAllOrdersUseCase {
  final OrderRepository repository;
  GetAllOrdersUseCase(this.repository);

  Stream<List<OrderEntity>> execute() {
    return repository.getAllOrdersStream();
  }
}
