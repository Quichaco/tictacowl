import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_config_viewmodel.dart';
import 'package:tictactoe_feature/src/providers/player_name_provider.dart';
import 'package:tictactoe_feature/src/providers/use_case_providers.dart';

part 'game_viewmodel.g.dart';

const _aiDelay = Duration(milliseconds: 600);

@riverpod
class GameViewModel extends _$GameViewModel {
  @override
  GameState build() {
    final config = ref.watch(gameConfigViewModelProvider);
    final playerName = ref.watch(playerNameProvider);

    return GameState.create(
      totalRounds: config.rounds,
      playerName: playerName,
    );
  }

  GameMode get _mode => ref.read(gameConfigViewModelProvider).mode;

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
    if (_mode.isMultiplayer) return;

    const aiPlayer = Player.o;
    if (state.isRoundOver || state.currentPlayer != aiPlayer) return;

    final roundBeforeDelay = state.currentRound;
    await Future.delayed(_aiDelay);

    if (state.currentRound != roundBeforeDelay) return;

    state = ref.read(aiMoveUseCaseProvider)(
      state: state,
      mode: _mode,
      aiPlayer: aiPlayer,
    );
  }
}
