import 'package:tictactoe_domain/src/models/game_state.dart';

class RestartGameUseCase {
  const RestartGameUseCase();

  /// Resets the entire match, preserving only grid size, total rounds and player name.
  GameState call(GameState state) {
    return GameState.create(
      gridSize: state.gridSize,
      totalRounds: state.totalRounds,
      playerName: state.playerName,
    );
  }
}
