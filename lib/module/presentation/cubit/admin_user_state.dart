import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';

abstract class AdminUserState {}

class AdminUserInitial extends AdminUserState {}

class AdminUserLoading extends AdminUserState {}

class AdminUserLoaded extends AdminUserState {
  final List<UserEntity> users;

  final int customerCount;
  final int adminCount;

  AdminUserLoaded(this.users)
    : customerCount = users
          .where((u) => u.role.toLowerCase() != 'admin')
          .length,
      adminCount = users.where((u) => u.role.toLowerCase() == 'admin').length;
}

class AdminUserError extends AdminUserState {
  final String message;
  AdminUserError(this.message);
}
