import 'package:tictactoe_domain/src/models/game_state.dart';
import 'package:tictactoe_domain/src/models/player.dart';

class PlayMoveUseCase {
  const PlayMoveUseCase();

  /// Places a move at [index]. Returns unchanged state if cell occupied or game over.
  GameState call({required GameState state, required int index}) {
    if (state.board[index] != null || state.isRoundOver) return state;

    final newBoard = List<Player?>.from(state.board);
    newBoard[index] = state.currentPlayer;

    // Creates state and computes derived fields (winner, winPattern, isRoundOver)
    final newState = GameState.create(
      board: newBoard,
      gridSize: state.gridSize,
      currentPlayer: state.currentPlayer.opponent,
      scoreX: state.scoreX,
      scoreO: state.scoreO,
      currentRound: state.currentRound,
      totalRounds: state.totalRounds,
      playerName: state.playerName,
    );

    if (newState.winner == null) return newState;

    // Update score on win
    return newState.copyWith(
      scoreX: newState.winner == Player.x ? state.scoreX + 1 : state.scoreX,
      scoreO: newState.winner == Player.o ? state.scoreO + 1 : state.scoreO,
    );
  }
}
