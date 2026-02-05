import 'package:common/common.dart';
import 'package:user_domain/src/models/user.dart';
import 'package:user_domain/src/repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  Future<Result<User?>> call(String uid) {
    return _repository.getUser(uid);
  }
}
