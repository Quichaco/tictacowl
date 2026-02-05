import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Navigation interface for tictactoe_feature.
///
/// Defines all navigation actions the feature needs.
/// The feature doesn't know about routes/paths - it only knows
/// about navigation intentions.
///
/// Must be implemented by the app layer which owns the actual routes.
abstract interface class GameNavigator {
  /// Exit to the home screen (outside tictactoe_feature).
  void exitToHome();
}

/// Provider for [GameNavigator].
///
/// Must be overridden in the app's ProviderScope.
final gameNavigatorProvider = Provider<GameNavigator>(
  (_) => throw UnimplementedError(
    'gameNavigatorProvider must be overridden in ProviderScope',
  ),
);
