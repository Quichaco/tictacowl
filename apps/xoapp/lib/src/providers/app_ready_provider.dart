import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_feature/user_feature.dart';

part 'app_ready_provider.g.dart';

@riverpod
bool appReady(Ref ref) {
  final (isAuthLoading, hasAuthUser) = ref.watch(
    authViewModelProvider.select((a) => (a.isLoading, a.value != null)),
  );

  if (isAuthLoading) return false;
  if (!hasAuthUser) return true; // Not authenticated = ready

  // Authenticated = wait for profile to load
  final isProfileLoading = ref.watch(
    userViewModelProvider.select((a) => a.isLoading),
  );
  return !isProfileLoading;
}
