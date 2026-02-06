/// Tests for [GamePreferencesRepositoryImpl] - game settings persistence.
///
/// Uses [SharedPreferences.setMockInitialValues] to test without actual
/// device storage.
///
/// Tested behaviors:
/// - [getGameMode]: Returns saved mode or default (multiplayer)
/// - [setGameMode]: Persists mode to SharedPreferences
/// - [getRounds]: Returns saved rounds or default (3)
/// - [setRounds]: Persists rounds with clamping to min/max bounds
///
/// Edge cases:
/// - Invalid stored values fall back to defaults
/// - Values outside bounds are clamped (not rejected)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/data/repositories/game_preferences_repository_impl.dart';

void main() {
  late SharedPreferences prefs;
  late GamePreferencesRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = GamePreferencesRepositoryImpl(prefs);
  });

  group('GamePreferencesRepositoryImpl', () {
    group('getGameMode', () {
      test('returns multiplayer by default', () {
        expect(repository.getGameMode(), equals(GameMode.multiplayer));
      });

      test('returns saved mode', () async {
        await prefs.setString('game_mode', 'easy');
        repository = GamePreferencesRepositoryImpl(prefs);

        expect(repository.getGameMode(), equals(GameMode.easy));
      });

      test('returns multiplayer for invalid mode string', () async {
        await prefs.setString('game_mode', 'invalid_mode');
        repository = GamePreferencesRepositoryImpl(prefs);

        expect(repository.getGameMode(), equals(GameMode.multiplayer));
      });
    });

    group('setGameMode', () {
      test('saves mode to preferences', () {
        repository.setGameMode(GameMode.hard);

        expect(prefs.getString('game_mode'), equals('hard'));
      });

      test('saved mode can be retrieved', () {
        repository.setGameMode(GameMode.medium);

        expect(repository.getGameMode(), equals(GameMode.medium));
      });
    });

    group('getRounds', () {
      test('returns 3 by default', () {
        expect(repository.getRounds(), equals(3));
      });

      test('returns saved rounds', () async {
        await prefs.setInt('game_rounds', 5);
        repository = GamePreferencesRepositoryImpl(prefs);

        expect(repository.getRounds(), equals(5));
      });
    });

    group('setRounds', () {
      test('saves rounds to preferences', () {
        repository.setRounds(7);

        expect(prefs.getInt('game_rounds'), equals(7));
      });

      test('clamps to minimum rounds', () {
        repository.setRounds(0);

        expect(prefs.getInt('game_rounds'), equals(GameConfig.minRounds));
      });

      test('clamps to maximum rounds', () {
        repository.setRounds(100);

        expect(prefs.getInt('game_rounds'), equals(GameConfig.maxRounds));
      });

      test('saved rounds can be retrieved', () {
        repository.setRounds(5);

        expect(repository.getRounds(), equals(5));
      });
    });
  });
}
