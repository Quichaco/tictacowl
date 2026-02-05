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

  static const _gameModeKey = 'game_mode';
  static const _roundsKey = 'game_rounds';

  @override
  GameMode getGameMode() {
    final raw = _prefs.getString(_gameModeKey);
    return GameMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => GameMode.multiplayer,
    );
  }

  @override
  void setGameMode(GameMode mode) {
    _prefs.setString(_gameModeKey, mode.name);
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
