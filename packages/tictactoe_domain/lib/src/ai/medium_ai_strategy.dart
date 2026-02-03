import 'dart:math';

import 'package:tictactoe_domain/src/ai/ai_strategy.dart';
import 'package:tictactoe_domain/src/models/player.dart';
import 'package:tictactoe_domain/src/utils/board_utils.dart';

/// Medium AI: wins, blocks, takes center, then random.
class MediumAiStrategy extends AiStrategy {
  const MediumAiStrategy([Random? random]) : _random = random;

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

    // 4. Random move
    return emptyCells[_rng.nextInt(emptyCells.length)];
  }
}
