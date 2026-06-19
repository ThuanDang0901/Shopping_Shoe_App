import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(String email, String password, String name);
  Future<void> signOut();
  // lấy tổng số lượng user
  Future<int> getTotalUsersCount();
  Future<List<UserEntity>> getUsers();
  Future<void> updateUserRole(String uid, String newRole);
  Future<void> updateUserStatus(String uid, bool isActive);
}
