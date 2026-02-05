import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/data/repositories/auth_repository_impl.dart';
import 'package:user_feature/src/data/repositories/user_repository_impl.dart';

part 'usecase_providers.g.dart';

// Auth UseCases
@riverpod
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignUpUseCase signUpUseCase(Ref ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
WatchAuthStateUseCase watchAuthStateUseCase(Ref ref) {
  return WatchAuthStateUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
}

// User Profile UseCases
@riverpod
GetUserUseCase getUserUseCase(Ref ref) {
  return GetUserUseCase(ref.watch(userRepositoryProvider));
}

@riverpod
SaveUserUseCase saveUserUseCase(Ref ref) {
  return SaveUserUseCase(ref.watch(userRepositoryProvider));
}
