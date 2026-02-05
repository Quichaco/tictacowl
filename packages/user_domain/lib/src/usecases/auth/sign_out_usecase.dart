import 'package:common/common.dart';
import 'package:user_domain/src/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Result<void>> call() {
    return _repository.signOut();
  }
}
