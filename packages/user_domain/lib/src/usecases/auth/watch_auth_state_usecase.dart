import 'package:user_domain/src/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository _repository;

  WatchAuthStateUseCase(this._repository);

  Stream<AuthUser?> call() {
    return _repository.authStateChanges;
  }
}
