import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/data/repositories/game_preferences_repository.dart';

part 'game_preferences_repository_impl.g.dart';

@Riverpod(keepAlive: true)
GamePreferencesRepository gamePreferencesRepository(Ref ref) {
  return GamePreferencesRepositoryImpl(ref.watch(sharedPreferencesProvider));
}

class GamePreferencesRepositoryImpl implements GamePreferencesRepository {
  GamePreferencesRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _difficultyKey = 'game_difficulty';
  static const _roundsKey = 'game_rounds';

  @override
  Difficulty getDifficulty() {
    final raw = _prefs.getString(_difficultyKey);
    return Difficulty.values.firstWhere(
      (d) => d.name == raw,
      orElse: () => Difficulty.easy,
    );
  }

  @override
  void setDifficulty(Difficulty difficulty) {
    _prefs.setString(_difficultyKey, difficulty.name);
  }

  @override
  int getRounds() => _prefs.getInt(_roundsKey) ?? 3;

  @override
  void setRounds(int rounds) {
    _prefs.setInt(
      _roundsKey,
      rounds.clamp(GameConfig.minRounds, GameConfig.maxRounds),
    );
  }
}
