import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_config_viewmodel.dart';
import 'package:tictactoe_feature/src/providers/use_case_providers.dart';

part 'game_viewmodel.g.dart';

@riverpod
class GameViewModel extends _$GameViewModel {
  late final PlayMoveUseCase _playMoveUseCase;
  late final NextRoundUseCase _nextRoundUseCase;
  late final RestartGameUseCase _restartGameUseCase;

  @override
  GameState build() {
    final config = ref.watch(gameConfigViewModelProvider);
    final userAsync = ref.watch(userViewModelProvider);
    final playerName = userAsync.maybeWhen(
      data: (user) => user?.name,
      orElse: () => null,
    );

    _playMoveUseCase = ref.read(playMoveUseCaseProvider);
    _nextRoundUseCase = ref.read(nextRoundUseCaseProvider);
    _restartGameUseCase = ref.read(restartGameUseCaseProvider);

    return GameState.create(
      totalRounds: config.rounds,
      playerName: playerName ?? '',
    );
  }

  void play(int index) => state = _playMoveUseCase(state, index);

  void next() => state = _nextRoundUseCase(state);

  void restart() => state = _restartGameUseCase(state);
}
