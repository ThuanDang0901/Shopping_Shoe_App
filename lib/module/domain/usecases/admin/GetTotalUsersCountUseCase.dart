import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';

class GetTotalUsersCountUseCase {
  final AuthRepository repository;

  GetTotalUsersCountUseCase(this.repository);

  Future<int> execute() async {
    return await repository.getTotalUsersCount();
  }
}
