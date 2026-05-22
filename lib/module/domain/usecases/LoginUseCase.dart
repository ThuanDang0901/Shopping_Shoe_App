import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<UserEntity> execute(String email, String password) {
    return repository.signIn(email, password);
  }
}
