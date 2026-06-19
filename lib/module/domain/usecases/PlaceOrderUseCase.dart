import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/OrderRepository.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart'; // Thêm mới

class PlaceOrderUseCase {
  final OrderRepository orderRepository;
  final ShoeRepository shoeRepository;

  PlaceOrderUseCase(this.orderRepository, this.shoeRepository);

  Future<void> execute(OrderEntity order) async {
    Map<String, int> stockUpdates = {};
    for (var item in order.items) {
      final shoeEntity = await shoeRepository.getShoeById(item.shoe.id);
      if (!shoeEntity.hasEnoughStock(item.quantity)) {
        throw Exception(
          "Sản phẩm '${shoeEntity.name}' không đủ hàng! "
          "Trong kho chỉ còn ${shoeEntity.stockQuantity} sản phẩm.",
        );
      }
      stockUpdates[shoeEntity.id] = shoeEntity.calculateRemainingStock(
        item.quantity,
      );
    }

    await orderRepository.placeOrderWithStock(
      order: order,
      stockUpdates: stockUpdates,
    );
  }
}
