import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<UserEntity> execute(String email, String password, String name) {
    return repository.signUp(email, password, name);
  }
}
