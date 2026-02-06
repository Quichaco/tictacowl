/// Tests for [GameConfigViewModel] - game configuration state management.
///
/// Verifies the ViewModel correctly:
/// - Initializes from saved preferences (mode, rounds)
/// - Updates mode and persists to repository
/// - Updates rounds with clamping and persists to repository
///
/// Uses mock SharedPreferences and a real ProviderContainer.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_config_viewmodel.dart';
import 'package:core/core.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('GameConfigViewModel', () {
    group('build (initialization)', () {
      test('returns default config when no saved preferences', () {
        final config = container.read(gameConfigViewModelProvider);

        expect(config.mode, equals(GameMode.multiplayer));
        expect(config.rounds, equals(3));
      });

      test('returns saved mode from preferences', () async {
        SharedPreferences.setMockInitialValues({'game_mode': 'hard'});
        final prefs = await SharedPreferences.getInstance();
        container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        final config = container.read(gameConfigViewModelProvider);

        expect(config.mode, equals(GameMode.hard));
      });

      test('returns saved rounds from preferences', () async {
        SharedPreferences.setMockInitialValues({'game_rounds': 5});
        final prefs = await SharedPreferences.getInstance();
        container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        final config = container.read(gameConfigViewModelProvider);

        expect(config.rounds, equals(5));
      });
    });

    group('setMode', () {
      test('updates state with new mode', () {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setMode(GameMode.easy);

        final config = container.read(gameConfigViewModelProvider);
        expect(config.mode, equals(GameMode.easy));
      });

      test('persists mode to repository', () async {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setMode(GameMode.medium);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('game_mode'), equals('medium'));
      });

      test('allows changing mode multiple times', () {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setMode(GameMode.easy);
        notifier.setMode(GameMode.hard);
        notifier.setMode(GameMode.multiplayer);

        final config = container.read(gameConfigViewModelProvider);
        expect(config.mode, equals(GameMode.multiplayer));
      });
    });

    group('setRounds', () {
      test('updates state with new rounds', () {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setRounds(7);

        final config = container.read(gameConfigViewModelProvider);
        expect(config.rounds, equals(7));
      });

      test('persists rounds to repository', () async {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setRounds(5);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('game_rounds'), equals(5));
      });

      test('clamps rounds to minimum', () {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setRounds(0);

        final config = container.read(gameConfigViewModelProvider);
        expect(config.rounds, equals(GameConfig.minRounds));
      });

      test('clamps rounds to maximum', () {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setRounds(100);

        final config = container.read(gameConfigViewModelProvider);
        expect(config.rounds, equals(GameConfig.maxRounds));
      });

      test('accepts valid rounds within bounds', () {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        for (int i = GameConfig.minRounds; i <= GameConfig.maxRounds; i++) {
          notifier.setRounds(i);
          expect(container.read(gameConfigViewModelProvider).rounds, equals(i));
        }
      });
    });

    group('state immutability', () {
      test('changing mode does not affect rounds', () {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setRounds(7);
        notifier.setMode(GameMode.hard);

        final config = container.read(gameConfigViewModelProvider);
        expect(config.rounds, equals(7));
        expect(config.mode, equals(GameMode.hard));
      });

      test('changing rounds does not affect mode', () {
        final notifier = container.read(gameConfigViewModelProvider.notifier);

        notifier.setMode(GameMode.easy);
        notifier.setRounds(5);

        final config = container.read(gameConfigViewModelProvider);
        expect(config.mode, equals(GameMode.easy));
        expect(config.rounds, equals(5));
      });
    });
  });
}
