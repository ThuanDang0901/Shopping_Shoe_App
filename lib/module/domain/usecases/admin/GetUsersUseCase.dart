import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';

class GetUsersUseCase {
  final AuthRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> execute() async {
    return await repository.getUsers();
  }
}
