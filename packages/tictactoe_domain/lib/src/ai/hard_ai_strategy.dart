import 'dart:math';

import 'package:tictactoe_domain/src/ai/ai_strategy.dart';
import 'package:tictactoe_domain/src/models/player.dart';
import 'package:tictactoe_domain/src/utils/board_utils.dart';

/// Hard AI: wins, blocks, takes center, picks best cell (corners prioritized).
class HardAiStrategy extends AiStrategy {
  const HardAiStrategy([Random? random]) : _random = random;

  final Random? _random;
  Random get _rng => _random ?? Random();

  @override
  int selectMove({
    required List<Player?> board,
    required int gridSize,
    required Player aiPlayer,
  }) {
    final emptyCells = BoardUtils.getEmptyCells(board);
    if (emptyCells.isEmpty) return -1;

    final opponent = aiPlayer.opponent;

    // 1. Win if possible
    final winMove = BoardUtils.findWinningMove(
      board: board,
      gridSize: gridSize,
      player: aiPlayer,
    );
    if (winMove != null) return winMove;

    // 2. Block opponent win
    final blockMove = BoardUtils.findWinningMove(
      board: board,
      gridSize: gridSize,
      player: opponent,
    );
    if (blockMove != null) return blockMove;

    // 3. Take center if available
    final center = (gridSize * gridSize) ~/ 2;
    if (board[center] == null) return center;

    // 4. Best cell (corners prioritized, then edges)
    return _selectBestCell(
      board: board,
      gridSize: gridSize,
      emptyCells: emptyCells,
      aiPlayer: aiPlayer,
      opponent: opponent,
    );
  }

  int _selectBestCell({
    required List<Player?> board,
    required int gridSize,
    required List<int> emptyCells,
    required Player aiPlayer,
    required Player opponent,
  }) {
    final patterns = BoardUtils.getWinPatterns(gridSize);
    final corners = BoardUtils.getCorners(gridSize);

    int bestScore = -1;
    int? bestCell;

    for (final cell in emptyCells) {
      int score = _calculateCellScore(
        board: board,
        cell: cell,
        patterns: patterns,
        aiPlayer: aiPlayer,
        opponent: opponent,
      );

      // Bonus for corners (strategic positions)
      if (corners.contains(cell)) score += 1;

      if (score > bestScore) {
        bestScore = score;
        bestCell = cell;
      }
    }

    return bestCell ?? emptyCells[_rng.nextInt(emptyCells.length)];
  }

  /// Score = sum of (1 + our marks) for each winnable pattern containing this cell.
  /// A pattern is winnable if it has no opponent mark.
  int _calculateCellScore({
    required List<Player?> board,
    required int cell,
    required List<List<int>> patterns,
    required Player aiPlayer,
    required Player opponent,
  }) {
    int score = 0;

    for (final pattern in patterns) {
      if (!pattern.contains(cell)) continue;

      // Skip if pattern is blocked by opponent
      final hasOpponent = pattern.any((i) => board[i] == opponent);
      if (hasOpponent) continue;

      // Count our marks in this winnable pattern
      final ourMarks = pattern.where((i) => board[i] == aiPlayer).length;

      // Score: 1 for winnable + bonus for each of our marks
      score += 1 + ourMarks;
    }

    return score;
  }
}
