/// Tests for AI strategies with different difficulty levels.
///
/// Uses [MockRandom] to make tests deterministic - without it, tests would
/// be flaky due to random move selection.
///
/// Strategy behaviors:
/// - [EasyAiStrategy]: Random empty cell selection
/// - [MediumAiStrategy]: Win > Block > Center > Random
/// - [HardAiStrategy]: Win > Block > Center > Corners > Random
///
/// Each strategy is injected with a controlled Random to verify the
/// decision-making logic in isolation.
library;

import 'dart:math';

import 'package:test/test.dart';
import 'package:tictactoe_domain/src/ai/easy_ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/medium_ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/hard_ai_strategy.dart';
import 'package:tictactoe_domain/src/models/player.dart';

/// Mock Random that returns predictable values for deterministic tests.
class MockRandom implements Random {
  MockRandom(this.nextValue);
  final int nextValue;

  @override
  int nextInt(int max) => nextValue % max;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0.0;
}

void main() {
  group('EasyAiStrategy', () {
    test('selects random empty cell or -1 for full board', () {
      final strategy = EasyAiStrategy(MockRandom(0));

      // Full board
      expect(strategy.selectMove(board: List.filled(9, Player.x), gridSize: 3, aiPlayer: Player.o), equals(-1));

      // Partial board - picks first empty (index 2)
      final board = [Player.x, Player.o, null, null, null, null, null, null, null];
      expect(strategy.selectMove(board: board, gridSize: 3, aiPlayer: Player.o), equals(2));

      // Different random value picks different cell
      final strategy2 = EasyAiStrategy(MockRandom(1));
      expect(strategy2.selectMove(board: board, gridSize: 3, aiPlayer: Player.o), equals(3));
    });
  });

  group('MediumAiStrategy', () {
    late MediumAiStrategy strategy;

    setUp(() => strategy = MediumAiStrategy(MockRandom(0)));

    test('prioritizes: win > block > center > random', () {
      // Wins when possible
      final canWin = [Player.o, Player.o, null, Player.x, Player.x, null, null, null, null];
      expect(strategy.selectMove(board: canWin, gridSize: 3, aiPlayer: Player.o), equals(2));

      // Blocks opponent win
      final mustBlock = [Player.x, Player.x, null, Player.o, null, null, null, null, null];
      expect(strategy.selectMove(board: mustBlock, gridSize: 3, aiPlayer: Player.o), equals(2));

      // Takes center when no win/block
      final takeCenter = [Player.x, null, null, null, null, null, null, null, null];
      expect(strategy.selectMove(board: takeCenter, gridSize: 3, aiPlayer: Player.o), equals(4));
    });
  });

  group('HardAiStrategy', () {
    late HardAiStrategy strategy;

    setUp(() => strategy = HardAiStrategy(MockRandom(0)));

    test('prioritizes: win > block > center > corners', () {
      // Wins when possible
      final canWin = [Player.o, Player.o, null, Player.x, Player.x, null, null, null, null];
      expect(strategy.selectMove(board: canWin, gridSize: 3, aiPlayer: Player.o), equals(2));

      // Blocks opponent win
      final mustBlock = [Player.x, Player.x, null, Player.o, null, null, null, null, null];
      expect(strategy.selectMove(board: mustBlock, gridSize: 3, aiPlayer: Player.o), equals(2));

      // Takes center
      final takeCenter = [Player.x, null, null, null, null, null, null, null, null];
      expect(strategy.selectMove(board: takeCenter, gridSize: 3, aiPlayer: Player.o), equals(4));

      // Prefers corners when center taken
      final preferCorner = [null, null, null, null, Player.x, null, null, null, null];
      expect([0, 2, 6, 8], contains(strategy.selectMove(board: preferCorner, gridSize: 3, aiPlayer: Player.o)));
    });
  });
}
