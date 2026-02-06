/// Tests for [BoardUtils] - core TicTacToe board logic.
///
/// This is pure domain logic with no dependencies, making it easy to test.
///
/// Tested functions:
/// - [getWinPatterns]: Generates all winning combinations (rows, cols, diagonals)
/// - [findWinPattern]: Detects which pattern caused a win
/// - [findWinner]: Returns the winning player or null
/// - [getEmptyCells]: Returns indices of unoccupied cells
/// - [findWinningMove]: Finds a move that would win for a player
/// - [getCorners]: Returns corner indices for AI strategy
///
/// Also verifies pattern caching for performance.
library;

import 'package:test/test.dart';
import 'package:tictactoe_domain/src/models/player.dart';
import 'package:tictactoe_domain/src/utils/board_utils.dart';

void main() {
  group('BoardUtils', () {
    group('getWinPatterns', () {
      test('returns all 8 patterns for 3x3 grid (rows, cols, diagonals)', () {
        final patterns = BoardUtils.getWinPatterns(3);
        expect(patterns.length, equals(8));
        // Rows
        expect(patterns.any((p) => p.join(',') == '0,1,2'), isTrue);
        expect(patterns.any((p) => p.join(',') == '3,4,5'), isTrue);
        expect(patterns.any((p) => p.join(',') == '6,7,8'), isTrue);
        // Columns
        expect(patterns.any((p) => p.join(',') == '0,3,6'), isTrue);
        expect(patterns.any((p) => p.join(',') == '1,4,7'), isTrue);
        expect(patterns.any((p) => p.join(',') == '2,5,8'), isTrue);
        // Diagonals
        expect(patterns.any((p) => p.join(',') == '0,4,8'), isTrue);
        expect(patterns.any((p) => p.join(',') == '2,4,6'), isTrue);
      });

      test('caches patterns for same grid size', () {
        final first = BoardUtils.getWinPatterns(3);
        final second = BoardUtils.getWinPatterns(3);
        expect(identical(first, second), isTrue);
      });
    });

    group('findWinPattern', () {
      test('detects wins in all directions', () {
        // Horizontal
        expect(
          BoardUtils.findWinPattern(
            board: [Player.x, Player.x, Player.x, null, null, null, null, null, null],
            gridSize: 3,
          ),
          equals([0, 1, 2]),
        );
        // Vertical
        expect(
          BoardUtils.findWinPattern(
            board: [Player.o, null, null, Player.o, null, null, Player.o, null, null],
            gridSize: 3,
          ),
          equals([0, 3, 6]),
        );
        // Diagonal
        expect(
          BoardUtils.findWinPattern(
            board: [Player.x, null, null, null, Player.x, null, null, null, Player.x],
            gridSize: 3,
          ),
          equals([0, 4, 8]),
        );
      });

      test('returns null when no winner', () {
        expect(BoardUtils.findWinPattern(board: List.filled(9, null), gridSize: 3), isNull);
        // Draw board
        final draw = [
          Player.x, Player.o, Player.x,
          Player.o, Player.x, Player.o,
          Player.o, Player.x, Player.o,
        ];
        expect(BoardUtils.findWinPattern(board: draw, gridSize: 3), isNull);
      });
    });

    group('findWinner', () {
      test('returns winner or null', () {
        expect(
          BoardUtils.findWinner(
            board: [Player.x, Player.x, Player.x, null, null, null, null, null, null],
            gridSize: 3,
          ),
          equals(Player.x),
        );
        expect(BoardUtils.findWinner(board: List.filled(9, null), gridSize: 3), isNull);
      });
    });

    group('getEmptyCells', () {
      test('returns correct empty cell indices', () {
        expect(BoardUtils.getEmptyCells(List.filled(9, null)), equals([0, 1, 2, 3, 4, 5, 6, 7, 8]));
        expect(BoardUtils.getEmptyCells(List.filled(9, Player.x)), isEmpty);
        expect(
          BoardUtils.getEmptyCells([Player.x, null, Player.o, null, Player.x, null, Player.o, null, Player.x]),
          equals([1, 3, 5, 7]),
        );
      });
    });

    group('findWinningMove', () {
      test('finds winning move in any direction', () {
        // Horizontal
        expect(
          BoardUtils.findWinningMove(
            board: [Player.x, Player.x, null, null, null, null, null, null, null],
            gridSize: 3,
            player: Player.x,
          ),
          equals(2),
        );
        // Vertical
        expect(
          BoardUtils.findWinningMove(
            board: [Player.o, null, null, Player.o, null, null, null, null, null],
            gridSize: 3,
            player: Player.o,
          ),
          equals(6),
        );
        // Diagonal
        expect(
          BoardUtils.findWinningMove(
            board: [Player.x, null, null, null, Player.x, null, null, null, null],
            gridSize: 3,
            player: Player.x,
          ),
          equals(8),
        );
      });

      test('returns null when no winning move', () {
        expect(
          BoardUtils.findWinningMove(
            board: [Player.x, Player.o, null, null, null, null, null, null, null],
            gridSize: 3,
            player: Player.x,
          ),
          isNull,
        );
      });
    });

    group('getCorners', () {
      test('returns corner indices for grid', () {
        expect(BoardUtils.getCorners(3), equals([0, 2, 6, 8]));
        expect(BoardUtils.getCorners(4), equals([0, 3, 12, 15]));
      });
    });
  });
}
