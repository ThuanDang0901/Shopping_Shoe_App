import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

class OrderListLoading extends OrderState {}

class OrderListLoaded extends OrderState {
  final List<OrderEntity> orders;
  OrderListLoaded(this.orders);
}

class OrderListError extends OrderState {
  final String message;
  OrderListError(this.message);
}
