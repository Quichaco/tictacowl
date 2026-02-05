import 'package:common/common.dart';
import 'package:user_domain/src/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Result<AuthUser>> call({
    required String email,
    required String password,
  }) {
    return _repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
