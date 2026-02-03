import 'package:tictactoe_domain/src/models/player.dart';

/// Shared utilities for board analysis.
abstract class BoardUtils {
  static final _patternsCache = <int, List<List<int>>>{};

  /// Returns all winning patterns for a given grid size.
  static List<List<int>> getWinPatterns(int size) {
    return _patternsCache.putIfAbsent(
      size,
      () => [
        // Rows
        for (var row = 0; row < size; row++)
          [for (var col = 0; col < size; col++) row * size + col],
        // Columns
        for (var col = 0; col < size; col++)
          [for (var row = 0; row < size; row++) row * size + col],
        // Diagonals
        [for (var i = 0; i < size; i++) i * (size + 1)],
        [for (var i = 0; i < size; i++) (i + 1) * (size - 1)],
      ],
    );
  }

  /// Returns the winning pattern if any, null otherwise.
  static List<int>? findWinPattern({
    required List<Player?> board,
    required int gridSize,
  }) {
    for (final pattern in getWinPatterns(gridSize)) {
      final first = board[pattern[0]];
      if (first != null && pattern.every((i) => board[i] == first)) {
        return pattern;
      }
    }
    return null;
  }

  /// Returns the winner if any, null otherwise.
  static Player? findWinner({
    required List<Player?> board,
    required int gridSize,
  }) {
    final pattern = findWinPattern(board: board, gridSize: gridSize);
    return pattern != null ? board[pattern[0]] : null;
  }

  /// Returns all empty cell indices.
  static List<int> getEmptyCells(List<Player?> board) {
    return [
      for (var i = 0; i < board.length; i++)
        if (board[i] == null) i,
    ];
  }

  /// Finds a move that would win for [player], or null if none exists.
  static int? findWinningMove({
    required List<Player?> board,
    required int gridSize,
    required Player player,
  }) {
    for (final pattern in getWinPatterns(gridSize)) {
      final cells = pattern.map((i) => board[i]).toList();
      final playerCount = cells.where((c) => c == player).length;
      final emptyCount = cells.where((c) => c == null).length;

      if (playerCount == gridSize - 1 && emptyCount == 1) {
        return pattern.firstWhere((i) => board[i] == null);
      }
    }
    return null;
  }

  /// Returns corner indices for a given grid size.
  static List<int> getCorners(int gridSize) {
    final last = gridSize - 1;
    return [0, last, gridSize * last, gridSize * last + last];
  }
}
