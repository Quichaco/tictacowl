import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictactoe_domain/src/models/player.dart';

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
    final winPattern = _findWinPattern(effectiveBoard, gridSize);
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

  static final _patternsCache = <int, List<List<int>>>{};

  static List<List<int>> _getWinPatterns(int size) {
    return _patternsCache.putIfAbsent(
      size,
      () => [
        // Row
        for (var row = 0; row < size; row++)
          [for (var col = 0; col < size; col++) row * size + col],
        // Column
        for (var col = 0; col < size; col++)
          [for (var row = 0; row < size; row++) row * size + col],
        // Diagonals
        [for (var i = 0; i < size; i++) i * (size + 1)],
        [for (var i = 0; i < size; i++) (i + 1) * (size - 1)],
      ],
    );
  }

  static List<int>? _findWinPattern(List<Player?> board, int gridSize) {
    for (final pattern in _getWinPatterns(gridSize)) {
      final first = board[pattern[0]];
      if (first != null && pattern.every((i) => board[i] == first)) {
        return pattern;
      }
    }
    return null;
  }
}
