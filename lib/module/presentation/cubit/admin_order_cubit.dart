// lib/module/presentation/cubit/admin_order_cubit.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetAllOrdersUseCase.dart';
import 'admin_order_state.dart';

class AdminOrderCubit extends Cubit<AdminOrderState> {
  final GetAllOrdersUseCase getAllOrdersUseCase;
  StreamSubscription? _ordersSubscription;

  AdminOrderCubit({required this.getAllOrdersUseCase})
    : super(AdminOrderInitial());

  void fetchAllOrders() {
    emit(AdminOrderLoading());
    _ordersSubscription?.cancel();

    _ordersSubscription = getAllOrdersUseCase.execute().listen(
      (ordersList) {
        if (!isClosed) emit(AdminOrderLoaded(ordersList));
      },
      onError: (error) {
        if (!isClosed) emit(AdminOrderError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
