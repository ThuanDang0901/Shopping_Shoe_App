import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';

class UpdateUserStatusUseCase {
  final AuthRepository repository;

  UpdateUserStatusUseCase(this.repository);

  Future<void> execute(String uid, bool isActive) async {
    return await repository.updateUserStatus(uid, isActive);
  }
}
