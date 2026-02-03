import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_config_viewmodel.dart';
import 'package:tictactoe_feature/src/providers/use_case_providers.dart';
import 'package:ui_components/ui_components.dart';

part 'game_viewmodel.g.dart';

@riverpod
class GameViewModel extends _$GameViewModel {
  @override
  GameState build() {
    final config = ref.watch(gameConfigViewModelProvider);
    final userAsync = ref.watch(userViewModelProvider);
    final playerName = userAsync.maybeWhen(
      data: (user) => user?.name,
      orElse: () => null,
    );

    return GameState.create(
      totalRounds: config.rounds,
      playerName: playerName ?? '',
    );
  }

  Difficulty get _difficulty =>
      ref.read(gameConfigViewModelProvider).difficulty;

  void play(int index) {
    state = ref.read(playMoveUseCaseProvider)(state: state, index: index);
    _playAiIfNeeded();
  }

  void next() {
    state = ref.read(nextRoundUseCaseProvider)(state);
    _playAiIfNeeded();
  }

  void restart() {
    state = ref.read(restartGameUseCaseProvider)(state);
  }

  Future<void> _playAiIfNeeded() async {
    const aiPlayer = Player.o;
    if (state.isGameOver || state.currentPlayer != aiPlayer) return;

    await Future.delayed(AppDurations.medium);
    state = ref.read(aiMoveUseCaseProvider)(
      state: state,
      difficulty: _difficulty,
      aiPlayer: aiPlayer,
    );
  }
}
