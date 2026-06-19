import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<void> placeOrderWithStock({
    required OrderEntity order,
    required Map<String, int> stockUpdates,
  });
  Stream<List<OrderEntity>> getOrdersByUserIdStream(String userId);
  // admin
  Stream<double> getTotalRevenueStream();
  Stream<int> getTotalOrdersCountStream();
  Stream<List<OrderEntity>> getRecentOrdersStream();
  Stream<List<OrderEntity>> getAllOrdersStream();
}
