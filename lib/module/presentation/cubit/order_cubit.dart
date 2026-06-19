import 'dart:async';
import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetUserOrdersUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/PlaceOrderUseCase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final PlaceOrderUseCase placeOrderUseCase;
  final GetUserOrdersUseCase getUserOrdersUseCase;
  StreamSubscription? _ordersSubscription;

  OrderCubit({
    required this.placeOrderUseCase,
    required this.getUserOrdersUseCase,
  }) : super(OrderInitial());

  void fetchUserOrders(String userId) {
    emit(OrderListLoading());

    _ordersSubscription?.cancel();

    _ordersSubscription = getUserOrdersUseCase
        .execute(userId)
        .listen(
          (ordersList) {
            if (!isClosed) emit(OrderListLoaded(ordersList));
          },
          onError: (error) {
            if (!isClosed) emit(OrderListError(error.toString()));
          },
        );
  }

  Future<void> submitOrder(OrderEntity order) async {
    emit(OrderLoading());
    try {
      await placeOrderUseCase.execute(order);
      emit(OrderSuccess());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
