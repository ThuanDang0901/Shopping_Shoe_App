import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetUsersUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/UpdateUserRoleUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/UpdateUserStatusUseCase.dart';
import 'admin_user_state.dart';

class AdminUserCubit extends Cubit<AdminUserState> {
  final GetUsersUseCase getUsersUseCase;
  final UpdateUserRoleUseCase updateUserRoleUseCase;
  final UpdateUserStatusUseCase updateUserStatusUseCase;

  AdminUserCubit({
    required this.getUsersUseCase,
    required this.updateUserRoleUseCase,
    required this.updateUserStatusUseCase,
  }) : super(AdminUserInitial());

  Future<void> fetchUsers() async {
    emit(AdminUserLoading());
    try {
      final users = await getUsersUseCase.execute();
      emit(AdminUserLoaded(users));
    } catch (e) {
      emit(AdminUserError(e.toString()));
    }
  }

  Future<void> changeUserRole(String uid, String newRole) async {
    try {
      await updateUserRoleUseCase.execute(uid, newRole);
      await fetchUsers();
    } catch (e) {
      emit(AdminUserError("Cập nhật quyền hạn thất bại: $e"));
    }
  }

  Future<void> toggleUserStatus(String uid, bool currentStatus) async {
    try {
      await updateUserStatusUseCase.execute(uid, !currentStatus);
      await fetchUsers();
    } catch (e) {
      emit(AdminUserError("Thay đổi trạng thái tài khoản thất bại: $e"));
    }
  }
}
