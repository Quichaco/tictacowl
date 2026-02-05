import 'package:common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/presentation/viewmodels/auth_viewmodel.dart';
import 'package:user_feature/src/providers/usecase_providers.dart';

part 'user_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class UserViewModel extends _$UserViewModel {
  @override
  Future<User?> build() async {
    final authUser = await ref.watch(authViewModelProvider.future);
    if (authUser == null) return null;

    final result = await ref.read(getUserUseCaseProvider).call(authUser.uid);
    return result.when(
      success: (user) => user,
      failure: (exception) => throw exception,
    );
  }

  Future<Result<User>> saveProfile(String name) async {
    final authUser = ref.read(authViewModelProvider).value;
    if (authUser == null) {
      return const Result.failure(
        AuthException(code: 'unauthenticated', message: 'User not signed in'),
      );
    }

    final result = await ref.read(saveUserUseCaseProvider).call(
          uid: authUser.uid,
          name: name.trim(),
          email: authUser.email,
        );

    if (result.isSuccess) {
      state = AsyncData(result.dataOrNull);
    }

    return result;
  }
}
