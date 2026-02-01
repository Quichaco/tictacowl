import 'package:user_domain/src/models/user.dart';
import 'package:user_domain/src/repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  Future<User?> call() => _repository.getUser();
}
