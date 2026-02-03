import 'package:tictactoe_domain/src/models/player.dart';

abstract class AiStrategy {
  const AiStrategy();

  /// Selects the best move for [aiPlayer] on the given [board].
  int selectMove({
    required List<Player?> board,
    required int gridSize,
    required Player aiPlayer,
  });
}
