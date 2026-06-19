import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_revenue_state.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetTotalRevenueUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetTotalOrdersCountUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetTotalProductsCountUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetTotalUsersCountUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetRecentOrdersUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';

class AdminRevenueCubit extends Cubit<AdminRevenueState> {
  final GetTotalRevenueUseCase getTotalRevenueUseCase;
  final GetTotalOrdersCountUseCase getTotalOrdersCountUseCase;
  final GetTotalProductsCountUseCase getTotalProductsCountUseCase;
  final GetTotalUsersCountUseCase getTotalUsersCountUseCase;
  final GetRecentOrdersUseCase getRecentOrdersUseCase;

  StreamSubscription? _adminDashboardSubscription;

  AdminRevenueCubit({
    required this.getTotalRevenueUseCase,
    required this.getTotalOrdersCountUseCase,
    required this.getTotalProductsCountUseCase,
    required this.getTotalUsersCountUseCase,
    required this.getRecentOrdersUseCase,
  }) : super(AdminRevenueInitial());

  void fetchRevenue() async {
    if (_adminDashboardSubscription != null) {
      await _adminDashboardSubscription!.cancel();
      _adminDashboardSubscription = null;
    }
    emit(AdminRevenueLoading());
    try {
      await _adminDashboardSubscription?.cancel();

      final staticResults = await Future.wait([
        getTotalProductsCountUseCase.execute(),
        getTotalUsersCountUseCase.execute(),
      ]);

      int productsCount = staticResults[0];
      int usersCount = staticResults[1];

      _adminDashboardSubscription = getRecentOrdersUseCase.execute().listen(
        (recentOrdersList) async {
          try {
            final totalOrdersCountRealtime = await getTotalOrdersCountUseCase
                .execute()
                .first;
            final revenueFromStats = await getTotalRevenueUseCase
                .execute()
                .first;

            double finalRevenue = 0.0;
            int finalOrdersCount = totalOrdersCountRealtime;

            if (totalOrdersCountRealtime <= recentOrdersList.length) {
              finalOrdersCount = recentOrdersList.length;
              for (var order in recentOrdersList) {
                finalRevenue += order.total;
              }
            } else {
              finalRevenue = revenueFromStats;
            }

            if (!isClosed) {
              emit(
                AdminRevenueLoaded(
                  finalRevenue,
                  finalOrdersCount,
                  productsCount,
                  usersCount,
                  recentOrdersList,
                ),
              );
            }
          } catch (internalError) {
            if (!isClosed) emit(AdminRevenueError(internalError.toString()));
          }
        },
        onError: (error) {
          if (!isClosed) emit(AdminRevenueError(error.toString()));
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminRevenueError(e.toString()));
    }
  }

  // Cần thiết: Đảm bảo huỷ lắng nghe khi đóng Cubit tránh rò rỉ bộ nhớ
  @override
  Future<void> close() {
    _adminDashboardSubscription?.cancel();
    return super.close();
  }
}
