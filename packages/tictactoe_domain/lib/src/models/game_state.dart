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

  /// Draw for current round (no winner and board full)
  bool get isRoundDraw => winner == null && board.every((c) => c != null);

  /// Current round is over
  bool get isRoundOver => winner != null || isRoundDraw;

  /// Rounds remaining after current one
  int get _remainingRounds => totalRounds - currentRound;

  /// Check if a player has mathematically won the match
  /// (opponent can't even tie by winning all remaining rounds)
  bool get _hasMatchWinner =>
      scoreX > scoreO + _remainingRounds || scoreO > scoreX + _remainingRounds;

  /// Match is over (last round finished OR someone mathematically won)
  bool get isMatchOver =>
      (isRoundOver && currentRound >= totalRounds) || _hasMatchWinner;

  /// Winner of the match based on total score (null if tied or not over)
  Player? get matchWinner {
    if (!isMatchOver) return null;
    if (scoreX > scoreO) return Player.x;
    if (scoreO > scoreX) return Player.o;
    return null; // Tie
  }

  /// Match ended in a tie (scores are equal)
  bool get isMatchDraw => isMatchOver && scoreX == scoreO;
}
