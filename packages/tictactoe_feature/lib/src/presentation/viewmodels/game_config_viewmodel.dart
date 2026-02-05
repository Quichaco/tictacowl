import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/data/repositories/game_preferences_repository_impl.dart';

part 'game_config_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class GameConfigViewModel extends _$GameConfigViewModel {
  @override
  GameConfig build() {
    final repo = ref.read(gamePreferencesRepositoryProvider);
    return GameConfig(
      mode: repo.getGameMode(),
      rounds: repo.getRounds(),
    );
  }

  void setMode(GameMode mode) {
    ref.read(gamePreferencesRepositoryProvider).setGameMode(mode);
    state = state.copyWith(mode: mode);
  }

  void setRounds(int rounds) {
    final clamped = rounds.clamp(GameConfig.minRounds, GameConfig.maxRounds);
    ref.read(gamePreferencesRepositoryProvider).setRounds(clamped);
    state = state.copyWith(rounds: clamped);
  }
}
