import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/OrderRepository.dart';

class GetUserOrdersUseCase {
  final OrderRepository repository;

  GetUserOrdersUseCase(this.repository);

  Stream<List<OrderEntity>> execute(String userId) {
    return repository.getOrdersByUserIdStream(userId);
  }
}
