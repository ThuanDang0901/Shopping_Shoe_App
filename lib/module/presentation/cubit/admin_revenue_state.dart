import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';

abstract class AdminRevenueState {}

class AdminRevenueInitial extends AdminRevenueState {}

class AdminRevenueLoading extends AdminRevenueState {}

class AdminRevenueLoaded extends AdminRevenueState {
  final double totalRevenue;
  final int totalOrders;
  final int totalProducts;
  final int totalUsers;
  final List<OrderEntity> recentOrders;
  AdminRevenueLoaded(
    this.totalRevenue,
    this.totalOrders,
    this.totalProducts,
    this.totalUsers,
    this.recentOrders,
  );
}

class AdminRevenueError extends AdminRevenueState {
  final String message;
  AdminRevenueError(this.message);
}
