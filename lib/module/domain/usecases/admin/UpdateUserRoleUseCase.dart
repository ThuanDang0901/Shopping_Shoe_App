import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';

class UpdateUserRoleUseCase {
  final AuthRepository repository;

  UpdateUserRoleUseCase(this.repository);

  Future<void> execute(String uid, String newRole) async {
    return await repository.updateUserRole(uid, newRole);
  }
}
