import 'package:tictactoe_domain/src/ai/ai_strategy_factory.dart';
import 'package:tictactoe_domain/src/models/game_mode.dart';
import 'package:tictactoe_domain/src/models/game_state.dart';
import 'package:tictactoe_domain/src/models/player.dart';
import 'package:tictactoe_domain/src/usecases/play_move_usecase.dart';

class AiMoveUseCase {
  const AiMoveUseCase({
    required PlayMoveUseCase playMoveUseCase,
    required AiStrategyFactory strategyFactory,
  })  : _playMoveUseCase = playMoveUseCase,
        _strategyFactory = strategyFactory;

  final PlayMoveUseCase _playMoveUseCase;
  final AiStrategyFactory _strategyFactory;

  /// Plays AI move if it's AI's turn. Returns unchanged state otherwise.
  GameState call({
    required GameState state,
    required GameMode mode,
    required Player aiPlayer,
  }) {
    if (state.currentPlayer != aiPlayer || state.isRoundOver) return state;

    final strategy = _strategyFactory.create(mode);
    final move = strategy.selectMove(
      board: state.board,
      gridSize: state.gridSize,
      aiPlayer: aiPlayer,
    );

    if (move < 0) return state;

    return _playMoveUseCase(state: state, index: move);
  }
}
