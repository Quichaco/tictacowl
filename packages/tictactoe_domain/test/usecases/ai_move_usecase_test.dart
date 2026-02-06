/// Tests for [AiMoveUseCase] - AI turn orchestration.
///
/// This use case coordinates AI move selection:
/// 1. Checks if it's actually the AI's turn
/// 2. Checks if round is still in progress
/// 3. Uses [AiStrategyFactory] to get the appropriate strategy
/// 4. Delegates to [PlayMoveUseCase] to execute the move
///
/// Guard conditions tested:
/// - Returns unchanged state if not AI's turn
/// - Returns unchanged state if round is over
///
/// Integration tested:
/// - AI correctly wins when winning move available
library;

import 'package:test/test.dart';
import 'package:tictactoe_domain/src/ai/ai_strategy_factory.dart';
import 'package:tictactoe_domain/src/models/game_mode.dart';
import 'package:tictactoe_domain/src/models/game_state.dart';
import 'package:tictactoe_domain/src/models/player.dart';
import 'package:tictactoe_domain/src/usecases/ai_move_usecase.dart';
import 'package:tictactoe_domain/src/usecases/play_move_usecase.dart';

void main() {
  group('AiMoveUseCase', () {
    late AiMoveUseCase useCase;

    setUp(() {
      useCase = const AiMoveUseCase(
        playMoveUseCase: PlayMoveUseCase(),
        strategyFactory: AiStrategyFactory(),
      );
    });

    test('plays AI move and switches player', () {
      final state = GameState.create(totalRounds: 3, playerName: 'Test', currentPlayer: Player.o);

      final newState = useCase(state: state, mode: GameMode.easy, aiPlayer: Player.o);

      expect(newState.board.where((c) => c == Player.o).length, equals(1));
      expect(newState.currentPlayer, equals(Player.x));
    });

    test('returns unchanged state when not AI turn or round over', () {
      // Not AI's turn
      final notAiTurn = GameState.create(totalRounds: 3, playerName: 'Test', currentPlayer: Player.x);
      expect(
        identical(useCase(state: notAiTurn, mode: GameMode.easy, aiPlayer: Player.o), notAiTurn),
        isTrue,
      );

      // Round over
      final roundOver = GameState.create(
        board: [Player.x, Player.x, Player.x, null, null, null, null, null, null],
        totalRounds: 3,
        playerName: 'Test',
        currentPlayer: Player.o,
      );
      expect(
        identical(useCase(state: roundOver, mode: GameMode.easy, aiPlayer: Player.o), roundOver),
        isTrue,
      );
    });

    test('AI wins when possible', () {
      final canWin = GameState.create(
        board: [Player.o, Player.o, null, Player.x, Player.x, null, null, null, null],
        totalRounds: 3,
        playerName: 'Test',
        currentPlayer: Player.o,
      );

      final won = useCase(state: canWin, mode: GameMode.medium, aiPlayer: Player.o);

      expect(won.winner, equals(Player.o));
      expect(won.board[2], equals(Player.o));
    });
  });
}
