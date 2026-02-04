import 'package:tictactoe_domain/src/models/game_state.dart';
import 'package:tictactoe_domain/src/models/player.dart';

class NextRoundUseCase {
  const NextRoundUseCase();

  /// Advances to next round. Loser starts, X starts on draw.
  GameState call(GameState state) {
    if (!state.isRoundOver || state.isMatchOver) return state;

    return GameState.create(
      gridSize: state.gridSize,
      currentPlayer: state.winner?.opponent ?? Player.x,
      scoreX: state.scoreX,
      scoreO: state.scoreO,
      currentRound: state.currentRound + 1,
      totalRounds: state.totalRounds,
      playerName: state.playerName,
    );
  }
}
