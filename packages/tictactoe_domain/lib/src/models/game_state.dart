import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictactoe_domain/src/models/player.dart';
import 'package:tictactoe_domain/src/utils/board_utils.dart';

part 'game_state.freezed.dart';

@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    required List<Player?> board,
    required int gridSize,
    required Player currentPlayer,
    required int scoreX,
    required int scoreO,
    required int currentRound,
    required int totalRounds,
    required String playerName,
    required List<int>? winPattern,
    required Player? winner,
  }) = _GameState;

  const GameState._();

  /// Creates a new [GameState] and computes derived fields ([winPattern], [winner]).
  factory GameState.create({
    List<Player?>? board,
    int gridSize = 3,
    Player currentPlayer = Player.x,
    int scoreX = 0,
    int scoreO = 0,
    int currentRound = 1,
    required int totalRounds,
    required String playerName,
  }) {
    final effectiveBoard = board ?? List.filled(gridSize * gridSize, null);
    final winPattern = BoardUtils.findWinPattern(
      board: effectiveBoard,
      gridSize: gridSize,
    );
    return GameState(
      board: effectiveBoard,
      gridSize: gridSize,
      currentPlayer: currentPlayer,
      scoreX: scoreX,
      scoreO: scoreO,
      currentRound: currentRound,
      totalRounds: totalRounds,
      playerName: playerName,
      winPattern: winPattern,
      winner: winPattern != null ? effectiveBoard[winPattern[0]] : null,
    );
  }

  bool get isDraw => winner == null && board.every((c) => c != null);

  bool get isGameOver => winner != null || isDraw;

  bool get isMatchOver => isGameOver && currentRound >= totalRounds;
}
