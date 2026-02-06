/// Tests for [GameViewModel] - game state management.
///
/// Verifies the ViewModel correctly:
/// - Initializes game state from config (rounds, player name)
/// - Plays moves and updates board state
/// - Handles round transitions (next round)
/// - Handles game restart
///
/// Uses mock providers and a real ProviderContainer.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_config_viewmodel.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_viewmodel.dart';
import 'package:tictactoe_feature/src/providers/player_name_provider.dart';
import 'package:core/core.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        playerNameProvider.overrideWith((ref) => 'TestPlayer'),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('GameViewModel', () {
    group('build (initialization)', () {
      test('initializes with correct total rounds from config', () {
        final state = container.read(gameViewModelProvider);

        expect(state.totalRounds, equals(3)); // Default from GameConfig
      });

      test('initializes with player name from provider', () {
        final state = container.read(gameViewModelProvider);

        expect(state.playerName, equals('TestPlayer'));
      });

      test('initializes with empty board', () {
        final state = container.read(gameViewModelProvider);

        expect(state.board.every((cell) => cell == null), isTrue);
      });

      test('initializes with X as current player', () {
        final state = container.read(gameViewModelProvider);

        expect(state.currentPlayer, equals(Player.x));
      });

      test('initializes with zero scores', () {
        final state = container.read(gameViewModelProvider);

        expect(state.scoreX, equals(0));
        expect(state.scoreO, equals(0));
      });

      test('initializes at round 1', () {
        final state = container.read(gameViewModelProvider);

        expect(state.currentRound, equals(1));
      });

      test('respects custom rounds from config', () async {
        SharedPreferences.setMockInitialValues({'game_rounds': 5});
        final prefs = await SharedPreferences.getInstance();
        container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            playerNameProvider.overrideWith((ref) => 'Player'),
          ],
        );

        final state = container.read(gameViewModelProvider);

        expect(state.totalRounds, equals(5));
      });
    });

    group('play', () {
      test('places X on first move', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        notifier.play(0);

        final state = container.read(gameViewModelProvider);
        expect(state.board[0], equals(Player.x));
      });

      test('switches to O after X plays', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        notifier.play(0);

        final state = container.read(gameViewModelProvider);
        expect(state.currentPlayer, equals(Player.o));
      });

      test('alternates players correctly', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        notifier.play(0); // X plays
        notifier.play(1); // O plays
        notifier.play(2); // X plays

        final state = container.read(gameViewModelProvider);
        expect(state.board[0], equals(Player.x));
        expect(state.board[1], equals(Player.o));
        expect(state.board[2], equals(Player.x));
        expect(state.currentPlayer, equals(Player.o));
      });

      test('does not allow playing on occupied cell', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        notifier.play(0); // X plays at 0
        notifier.play(0); // Try to play at 0 again

        final state = container.read(gameViewModelProvider);
        expect(state.board[0], equals(Player.x)); // Still X
        expect(state.currentPlayer, equals(Player.o)); // Still O's turn
      });

      test('detects winner (horizontal)', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // X: 0, 1, 2 (top row)
        // O: 3, 4
        notifier.play(0); // X
        notifier.play(3); // O
        notifier.play(1); // X
        notifier.play(4); // O
        notifier.play(2); // X wins

        final state = container.read(gameViewModelProvider);
        expect(state.winner, equals(Player.x));
        expect(state.isRoundOver, isTrue);
        expect(state.scoreX, equals(1));
      });

      test('detects winner (vertical)', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // X: 0, 3, 6 (left column)
        // O: 1, 4
        notifier.play(0); // X
        notifier.play(1); // O
        notifier.play(3); // X
        notifier.play(4); // O
        notifier.play(6); // X wins

        final state = container.read(gameViewModelProvider);
        expect(state.winner, equals(Player.x));
        expect(state.winPattern, containsAll([0, 3, 6]));
      });

      test('detects winner (diagonal)', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // X: 0, 4, 8 (main diagonal)
        // O: 1, 2
        notifier.play(0); // X
        notifier.play(1); // O
        notifier.play(4); // X
        notifier.play(2); // O
        notifier.play(8); // X wins

        final state = container.read(gameViewModelProvider);
        expect(state.winner, equals(Player.x));
        expect(state.winPattern, containsAll([0, 4, 8]));
      });

      test('detects draw', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // Draw board:
        // X O X
        // X X O
        // O X O
        notifier.play(0); // X
        notifier.play(1); // O
        notifier.play(2); // X
        notifier.play(5); // O
        notifier.play(3); // X
        notifier.play(6); // O
        notifier.play(4); // X
        notifier.play(8); // O
        notifier.play(7); // X

        final state = container.read(gameViewModelProvider);
        expect(state.winner, isNull);
        expect(state.isRoundDraw, isTrue);
        expect(state.isRoundOver, isTrue);
      });

      test('does not allow play after round is over', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // X wins
        notifier.play(0);
        notifier.play(3);
        notifier.play(1);
        notifier.play(4);
        notifier.play(2); // X wins

        final stateBeforeExtraPlay = container.read(gameViewModelProvider);
        notifier.play(5); // Should be ignored

        final stateAfterExtraPlay = container.read(gameViewModelProvider);
        expect(stateAfterExtraPlay, equals(stateBeforeExtraPlay));
      });
    });

    group('next', () {
      test('advances to next round after win', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // X wins round 1
        notifier.play(0);
        notifier.play(3);
        notifier.play(1);
        notifier.play(4);
        notifier.play(2);

        notifier.next();

        final state = container.read(gameViewModelProvider);
        expect(state.currentRound, equals(2));
        expect(state.board.every((c) => c == null), isTrue);
      });

      test('preserves scores across rounds', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // X wins round 1
        notifier.play(0);
        notifier.play(3);
        notifier.play(1);
        notifier.play(4);
        notifier.play(2);

        notifier.next();

        final state = container.read(gameViewModelProvider);
        expect(state.scoreX, equals(1));
        expect(state.scoreO, equals(0));
      });

      test('loser starts next round', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // X wins round 1
        notifier.play(0);
        notifier.play(3);
        notifier.play(1);
        notifier.play(4);
        notifier.play(2);

        notifier.next();

        final state = container.read(gameViewModelProvider);
        expect(state.currentPlayer, equals(Player.o));
      });
    });

    group('restart', () {
      test('resets game to initial state', () {
        final notifier = container.read(gameViewModelProvider.notifier);

        // Play some moves
        notifier.play(0);
        notifier.play(1);
        notifier.play(2);

        notifier.restart();

        final state = container.read(gameViewModelProvider);
        expect(state.board.every((c) => c == null), isTrue);
        expect(state.currentRound, equals(1));
        expect(state.scoreX, equals(0));
        expect(state.scoreO, equals(0));
        expect(state.currentPlayer, equals(Player.x));
      });

      test('can restart after match is over', () {
        // Set rounds to 1 for quick match
        container.read(gameConfigViewModelProvider.notifier).setRounds(1);

        // Refresh the game state
        container.invalidate(gameViewModelProvider);

        final notifier = container.read(gameViewModelProvider.notifier);

        // X wins the only round
        notifier.play(0);
        notifier.play(3);
        notifier.play(1);
        notifier.play(4);
        notifier.play(2);

        expect(container.read(gameViewModelProvider).isMatchOver, isTrue);

        notifier.restart();

        final state = container.read(gameViewModelProvider);
        expect(state.isMatchOver, isFalse);
        expect(state.currentRound, equals(1));
      });
    });

    group('reactivity', () {
      test('rebuilds when config changes', () async {
        final initialState = container.read(gameViewModelProvider);
        expect(initialState.totalRounds, equals(3));

        // Change config
        SharedPreferences.setMockInitialValues({'game_rounds': 7});
        final prefs = await SharedPreferences.getInstance();

        // Need to create new container to reflect prefs change
        container.dispose();
        container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            playerNameProvider.overrideWith((ref) => 'TestPlayer'),
          ],
        );

        final newState = container.read(gameViewModelProvider);
        expect(newState.totalRounds, equals(7));
      });

      test('uses updated player name', () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        container.dispose();
        container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            playerNameProvider.overrideWith((ref) => 'NewPlayerName'),
          ],
        );

        final state = container.read(gameViewModelProvider);
        expect(state.playerName, equals('NewPlayerName'));
      });
    });
  });
}
