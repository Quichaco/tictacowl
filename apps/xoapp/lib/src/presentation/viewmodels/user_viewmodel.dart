import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';
import 'package:xoapp/src/common/providers/usecase_providers.dart';

part 'user_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class UserViewModel extends _$UserViewModel {
  @override
  Future<User?> build() => ref.watch(getUserUseCaseProvider).call();

  Future<void> saveUser(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(saveUserUseCaseProvider).call(name),
    );
  }
}
