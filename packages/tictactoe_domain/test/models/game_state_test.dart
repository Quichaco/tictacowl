/// Tests for [GameState] computed properties.
///
/// [GameState] is a Freezed class with computed properties that derive
/// game status from the current board state.
///
/// Tested properties:
/// - [create]: Factory that computes winner/winPattern from board
/// - [isRoundDraw]: True when board full with no winner
/// - [isRoundOver]: True when winner exists or draw
/// - [isMatchOver]: True when last round or mathematically won
/// - [matchWinner]: Returns overall match winner
/// - [isMatchDraw]: True when match ends in tie
///
/// Note: Basic properties (board, scores, etc.) are not tested as they're
/// simple Freezed getters.
library;

import 'package:test/test.dart';
import 'package:tictactoe_domain/src/models/game_state.dart';
import 'package:tictactoe_domain/src/models/player.dart';

void main() {
  group('GameState', () {
    group('create', () {
      test('initializes with defaults and computes win state', () {
        final state = GameState.create(totalRounds: 3, playerName: 'Test');
        expect(state.board.length, equals(9));
        expect(state.board.every((c) => c == null), isTrue);
        expect(state.gridSize, equals(3));
        expect(state.currentPlayer, equals(Player.x));
        expect(state.scoreX, equals(0));
        expect(state.scoreO, equals(0));
        expect(state.currentRound, equals(1));
        expect(state.winPattern, isNull);
        expect(state.winner, isNull);
      });

      test('computes winner and winPattern from board', () {
        final board = [
          Player.x, Player.x, Player.x,
          Player.o, Player.o, null,
          null, null, null,
        ];
        final state = GameState.create(board: board, totalRounds: 3, playerName: 'Test');
        expect(state.winPattern, equals([0, 1, 2]));
        expect(state.winner, equals(Player.x));
      });
    });

    group('isRoundDraw', () {
      test('true when board full with no winner, false otherwise', () {
        final draw = [
          Player.x, Player.o, Player.x,
          Player.x, Player.o, Player.o,
          Player.o, Player.x, Player.x,
        ];
        expect(GameState.create(board: draw, totalRounds: 3, playerName: 'Test').isRoundDraw, isTrue);

        // Has winner - not draw
        final win = [Player.x, Player.x, Player.x, null, null, null, null, null, null];
        expect(GameState.create(board: win, totalRounds: 3, playerName: 'Test').isRoundDraw, isFalse);

        // Not full - not draw
        expect(GameState.create(totalRounds: 3, playerName: 'Test').isRoundDraw, isFalse);
      });
    });

    group('isRoundOver', () {
      test('true when winner exists or draw', () {
        final win = [Player.x, Player.x, Player.x, null, null, null, null, null, null];
        expect(GameState.create(board: win, totalRounds: 3, playerName: 'Test').isRoundOver, isTrue);

        final draw = [
          Player.x, Player.o, Player.x,
          Player.x, Player.o, Player.o,
          Player.o, Player.x, Player.x,
        ];
        expect(GameState.create(board: draw, totalRounds: 3, playerName: 'Test').isRoundOver, isTrue);

        expect(GameState.create(totalRounds: 3, playerName: 'Test').isRoundOver, isFalse);
      });
    });

    group('isMatchOver', () {
      test('true when last round finished or player mathematically won', () {
        // Last round with winner
        final board = [Player.x, Player.x, Player.x, null, null, null, null, null, null];
        expect(
          GameState.create(board: board, currentRound: 3, totalRounds: 3, playerName: 'Test').isMatchOver,
          isTrue,
        );

        // Mathematically won (2-0 with 1 round left)
        expect(
          GameState.create(scoreX: 2, scoreO: 0, currentRound: 2, totalRounds: 3, playerName: 'Test').isMatchOver,
          isTrue,
        );

        // Can still be tied
        expect(
          GameState.create(scoreX: 1, scoreO: 0, currentRound: 1, totalRounds: 3, playerName: 'Test').isMatchOver,
          isFalse,
        );
      });
    });

    group('matchWinner and isMatchDraw', () {
      test('returns correct winner or null for draw', () {
        final board = [Player.x, Player.x, Player.x, null, null, null, null, null, null];

        // X wins
        final xWins = GameState.create(
          board: board, scoreX: 2, scoreO: 1, currentRound: 3, totalRounds: 3, playerName: 'Test',
        );
        expect(xWins.matchWinner, equals(Player.x));
        expect(xWins.isMatchDraw, isFalse);

        // Draw
        final draw = GameState.create(
          board: board, scoreX: 1, scoreO: 1, currentRound: 3, totalRounds: 3, playerName: 'Test',
        );
        expect(draw.matchWinner, isNull);
        expect(draw.isMatchDraw, isTrue);

        // Match not over
        expect(GameState.create(totalRounds: 3, playerName: 'Test').matchWinner, isNull);
      });
    });
  });
}
