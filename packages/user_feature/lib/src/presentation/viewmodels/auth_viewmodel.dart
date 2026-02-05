import 'package:common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/providers/usecase_providers.dart';

part 'auth_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  Stream<AuthUser?> build() {
    return ref.watch(watchAuthStateUseCaseProvider).call();
  }

  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) {
    return ref.read(signInUseCaseProvider).call(
          email: email.trim(),
          password: password,
        );
  }

  Future<Result<AuthUser>> signUp({
    required String email,
    required String password,
  }) {
    return ref.read(signUpUseCaseProvider).call(
          email: email.trim(),
          password: password,
        );
  }

  Future<Result<void>> signOut() {
    return ref.read(signOutUseCaseProvider).call();
  }

  Future<Result<void>> resetPassword({required String email}) {
    return ref.read(resetPasswordUseCaseProvider).call(email: email.trim());
  }
}
