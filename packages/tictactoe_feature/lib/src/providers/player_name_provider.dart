import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the current player's name.
///
/// Must be overridden in the app's ProviderScope.
/// This allows tictactoe_feature to display the player name
/// without depending on user_feature.
final playerNameProvider = Provider<String>(
  (_) => throw UnimplementedError(
    'playerNameProvider must be overridden in ProviderScope',
  ),
);
