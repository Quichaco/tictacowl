import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Navigation interface for user_feature.
///
/// Defines all navigation actions the feature needs.
/// The feature doesn't know about routes/paths - it only knows
/// about navigation intentions.
///
/// Must be implemented by the app layer which owns the actual routes.
abstract interface class UserNavigator {
  /// Navigate to the login screen.
  void goToLogin();

  /// Navigate to the sign up screen.
  void goToSignUp();

  /// Navigate to the forgot password screen.
  void goToForgotPassword();

}

/// Provider for [UserNavigator].
///
/// Must be overridden in the app's ProviderScope.
final userNavigatorProvider = Provider<UserNavigator>(
  (_) => throw UnimplementedError(
    'userNavigatorProvider must be overridden in ProviderScope',
  ),
);
