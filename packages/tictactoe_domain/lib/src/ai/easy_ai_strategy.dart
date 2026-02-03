import 'dart:math';

import 'package:tictactoe_domain/src/ai/ai_strategy.dart';
import 'package:tictactoe_domain/src/models/player.dart';
import 'package:tictactoe_domain/src/utils/board_utils.dart';

/// AI that plays random moves.
class EasyAiStrategy extends AiStrategy {
  const EasyAiStrategy([Random? random]) : _random = random;

  final Random? _random;

  @override
  int selectMove({
    required List<Player?> board,
    required int gridSize,
    required Player aiPlayer,
  }) {
    final emptyCells = BoardUtils.getEmptyCells(board);
    if (emptyCells.isEmpty) return -1;

    final random = _random ?? Random();
    return emptyCells[random.nextInt(emptyCells.length)];
  }
}
