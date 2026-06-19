// lib/module/presentation/cubit/admin_order_state.dart

import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';

abstract class AdminOrderState {}

class AdminOrderInitial extends AdminOrderState {}

class AdminOrderLoading extends AdminOrderState {}

class AdminOrderLoaded extends AdminOrderState {
  final List<OrderEntity> orders;
  AdminOrderLoaded(this.orders);
}

class AdminOrderError extends AdminOrderState {
  final String message;
  AdminOrderError(this.message);
}
