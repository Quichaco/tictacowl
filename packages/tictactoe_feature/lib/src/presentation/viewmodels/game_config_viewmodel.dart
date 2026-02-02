import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/providers/game_preferences_repository_provider.dart';

part 'game_config_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class GameConfigViewModel extends _$GameConfigViewModel {
  @override
  GameConfig build() {
    final repo = ref.read(gamePreferencesRepositoryProvider);
    return GameConfig(
      difficulty: repo.getDifficulty(),
      rounds: repo.getRounds(),
    );
  }

  void setDifficulty(Difficulty difficulty) {
    ref.read(gamePreferencesRepositoryProvider).setDifficulty(difficulty);
    state = state.copyWith(difficulty: difficulty);
  }

  void setRounds(int rounds) {
    final clamped = rounds.clamp(GameConfig.minRounds, GameConfig.maxRounds);
    ref.read(gamePreferencesRepositoryProvider).setRounds(clamped);
    state = state.copyWith(rounds: clamped);
  }
}
