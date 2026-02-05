import 'package:common/common.dart';
import 'package:user_domain/src/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Result<void>> call({required String email}) {
    return _repository.resetPassword(email: email);
  }
}
