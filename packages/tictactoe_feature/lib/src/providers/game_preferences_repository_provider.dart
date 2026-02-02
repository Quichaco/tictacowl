import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';

part 'game_preferences_repository_provider.g.dart';

@Riverpod(keepAlive: true)
GamePreferencesRepository gamePreferencesRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return GamePreferencesRepository(prefs);
}

/// Repository for persisting game configuration.
class GamePreferencesRepository {
  GamePreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _difficultyKey = 'game_difficulty';
  static const _roundsKey = 'game_rounds';

  Difficulty getDifficulty() {
    final raw = _prefs.getString(_difficultyKey);
    return Difficulty.values.firstWhere(
      (d) => d.name == raw,
      orElse: () => Difficulty.easy,
    );
  }

  void setDifficulty(Difficulty difficulty) {
    _prefs.setString(_difficultyKey, difficulty.name);
  }

  int getRounds() => _prefs.getInt(_roundsKey) ?? 3;

  void setRounds(int rounds) {
    _prefs.setInt(
      _roundsKey,
      rounds.clamp(GameConfig.minRounds, GameConfig.maxRounds),
    );
  }
}
