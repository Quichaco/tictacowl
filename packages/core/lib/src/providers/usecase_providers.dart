import 'package:core/src/data/repositories/user_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';

part 'usecase_providers.g.dart';

@riverpod
GetUserUseCase getUserUseCase(Ref ref) {
  return GetUserUseCase(ref.watch(userRepositoryProvider));
}

@riverpod
SaveUserUseCase saveUserUseCase(Ref ref) {
  return SaveUserUseCase(ref.watch(userRepositoryProvider));
}
