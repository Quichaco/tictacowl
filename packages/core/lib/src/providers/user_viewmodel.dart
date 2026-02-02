import 'package:core/src/providers/usecase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';

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
