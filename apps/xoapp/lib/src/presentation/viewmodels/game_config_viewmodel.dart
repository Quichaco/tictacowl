import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:xoapp/src/data/repositories/app_preferences_repository_impl.dart';

part 'game_config_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class GameConfigViewModel extends _$GameConfigViewModel {
  @override
  GameConfig build() {
    final repo = ref.read(appPreferencesRepositoryProvider);
    return GameConfig(
      difficulty: repo.getDifficulty(),
      rounds: repo.getRounds(),
    );
  }

  void setDifficulty(Difficulty difficulty) {
    ref.read(appPreferencesRepositoryProvider).setDifficulty(difficulty);
    state = state.copyWith(difficulty: difficulty);
  }

  void setRounds(int rounds) {
    final clamped = rounds.clamp(GameConfig.minRounds, GameConfig.maxRounds);
    ref.read(appPreferencesRepositoryProvider).setRounds(clamped);
    state = state.copyWith(rounds: clamped);
  }
}
