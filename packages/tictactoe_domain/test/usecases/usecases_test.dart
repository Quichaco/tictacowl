/// Tests for game use cases - core game flow logic.
///
/// These use cases are pure functions that transform [GameState]:
///
/// - [PlayMoveUseCase]: Places a move, switches player, updates score on win
///   - Returns unchanged state if cell occupied or round over
///
/// - [NextRoundUseCase]: Advances to next round after round ends
///   - Loser starts next round (or X on draw)
///   - Returns unchanged state if round not over or match over
///
/// - [RestartGameUseCase]: Resets game while preserving config
///   - Clears board, scores, round counter
///   - Keeps totalRounds, gridSize, playerName
library;

import 'package:test/test.dart';
import 'package:tictactoe_domain/src/models/game_state.dart';
import 'package:tictactoe_domain/src/models/player.dart';
import 'package:tictactoe_domain/src/usecases/play_move_usecase.dart';
import 'package:tictactoe_domain/src/usecases/next_round_usecase.dart';
import 'package:tictactoe_domain/src/usecases/restart_game_usecase.dart';

void main() {
  group('PlayMoveUseCase', () {
    late PlayMoveUseCase useCase;

    setUp(() => useCase = const PlayMoveUseCase());

    test('places move, switches player, updates score on win', () {
      final state = GameState.create(totalRounds: 3, playerName: 'Test');

      // Normal move
      final afterMove = useCase(state: state, index: 0);
      expect(afterMove.board[0], equals(Player.x));
      expect(afterMove.currentPlayer, equals(Player.o));
      expect(afterMove.scoreX, equals(0));

      // Winning move
      final almostWin = GameState.create(
        board: [Player.x, Player.x, null, Player.o, Player.o, null, null, null, null],
        totalRounds: 3,
        playerName: 'Test',
      );
      final won = useCase(state: almostWin, index: 2);
      expect(won.winner, equals(Player.x));
      expect(won.scoreX, equals(1));
    });

    test('returns unchanged state when cell occupied or round over', () {
      // Occupied cell
      final occupied = GameState.create(
        board: [Player.x, null, null, null, null, null, null, null, null],
        totalRounds: 3,
        playerName: 'Test',
      );
      expect(identical(useCase(state: occupied, index: 0), occupied), isTrue);

      // Round over
      final over = GameState.create(
        board: [Player.x, Player.x, Player.x, null, null, null, null, null, null],
        totalRounds: 3,
        playerName: 'Test',
      );
      expect(identical(useCase(state: over, index: 3), over), isTrue);
    });
  });

  group('NextRoundUseCase', () {
    late NextRoundUseCase useCase;

    setUp(() => useCase = const NextRoundUseCase());

    test('advances round with loser starting, preserves scores', () {
      final state = GameState.create(
        board: [Player.x, Player.x, Player.x, null, null, null, null, null, null],
        scoreX: 1,
        scoreO: 0,
        currentRound: 1,
        totalRounds: 3,
        playerName: 'Test',
      );

      final next = useCase(state);
      expect(next.currentRound, equals(2));
      expect(next.currentPlayer, equals(Player.o)); // loser starts
      expect(next.board.every((c) => c == null), isTrue);
      expect(next.scoreX, equals(1));
    });

    test('X starts on draw, returns unchanged when not over or match over', () {
      // Draw - X starts
      final draw = GameState.create(
        board: [
          Player.x, Player.o, Player.x,
          Player.x, Player.o, Player.o,
          Player.o, Player.x, Player.x,
        ],
        currentRound: 1,
        totalRounds: 3,
        playerName: 'Test',
      );
      expect(useCase(draw).currentPlayer, equals(Player.x));

      // Round not over
      final notOver = GameState.create(totalRounds: 3, playerName: 'Test');
      expect(identical(useCase(notOver), notOver), isTrue);

      // Match over
      final matchOver = GameState.create(
        board: [Player.x, Player.x, Player.x, null, null, null, null, null, null],
        scoreX: 2,
        currentRound: 3,
        totalRounds: 3,
        playerName: 'Test',
      );
      expect(identical(useCase(matchOver), matchOver), isTrue);
    });
  });

  group('RestartGameUseCase', () {
    late RestartGameUseCase useCase;

    setUp(() => useCase = const RestartGameUseCase());

    test('resets everything except config, X starts', () {
      final state = GameState.create(
        board: [Player.x, Player.x, Player.x, null, null, null, null, null, null],
        scoreX: 2,
        scoreO: 1,
        currentRound: 3,
        currentPlayer: Player.o,
        totalRounds: 5,
        playerName: 'CustomName',
      );

      final restarted = useCase(state);
      expect(restarted.board.every((c) => c == null), isTrue);
      expect(restarted.scoreX, equals(0));
      expect(restarted.scoreO, equals(0));
      expect(restarted.currentRound, equals(1));
      expect(restarted.currentPlayer, equals(Player.x));
      // Preserved
      expect(restarted.totalRounds, equals(5));
      expect(restarted.playerName, equals('CustomName'));
    });
  });
}
