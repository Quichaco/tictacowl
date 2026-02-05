import 'package:common/common.dart';
import 'package:user_domain/src/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Result<AuthUser>> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
