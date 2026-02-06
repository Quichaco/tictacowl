import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_feature/src/presentation/widgets/board/game_cell.dart';
import 'package:ui_components/ui_components.dart';

import 'helpers/test_app.dart';

void main() {
  Future<void> tapCell(WidgetTester tester, int index) async {
    final cells = find.byType(GameCell);
    if (cells.evaluate().length > index) {
      await tester.tap(cells.at(index));
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  Future<void> playUntilRoundEnds(WidgetTester tester) async {
    for (var i = 0; i < 9; i++) {
      if (findVictoryDialog().evaluate().isNotEmpty) break;
      await tapCell(tester, i);
      await settle(tester);
    }
    await waitFor(tester, findVictoryDialog(), timeout: const Duration(seconds: 5));
  }

  Future<void> startGame(WidgetTester tester) async {
    await tester.pumpWidget(await createTestApp());
    await settle(tester);
    await tester.tap(find.byType(GradientButton));
    await settle(tester);
  }

  group('Game Flow', () {
    testWidgets('starts game and shows board', (tester) async {
      await tester.pumpWidget(await createTestApp());
      await settle(tester);

      expect(find.byType(GradientButton), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.byType(GradientButton));
      await settle(tester);

      expect(find.text('VS'), findsOneWidget);
      expect(find.text('1/3'), findsOneWidget);
      expect(find.byType(GameCell), findsNWidgets(9));
    });

    testWidgets('plays moves on the board', (tester) async {
      await startGame(tester);

      await tapCell(tester, 4);
      await settle(tester);

      expect(find.text('VS'), findsOneWidget);
    });

    testWidgets('plays until round ends with victory dialog', (tester) async {
      await startGame(tester);
      await playUntilRoundEnds(tester);

      expect(findVictoryDialog(), findsOneWidget);
    });

    testWidgets('continues to next round after victory', (tester) async {
      await startGame(tester);
      await playUntilRoundEnds(tester);
      await settle(tester);

      final nextButton = find.byIcon(Icons.arrow_forward);
      if (nextButton.evaluate().isNotEmpty) {
        await tester.tap(nextButton);
        await settle(tester);
        expect(find.text('2/3'), findsOneWidget);
      }
    });

    testWidgets('completes a 1-round match', (tester) async {
      await tester.pumpWidget(await createTestApp());
      await settle(tester);

      // Set to 1 round
      await tester.tap(find.byIcon(Icons.remove));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.remove));
      await settle(tester);

      await tester.tap(find.byType(GradientButton));
      await settle(tester);
      expect(find.text('1/1'), findsOneWidget);

      await playUntilRoundEnds(tester);
      await settle(tester);

      expect(findVictoryDialog(), findsOneWidget);
      final hasEndOptions = find.byIcon(Icons.replay).evaluate().isNotEmpty ||
          find.text('Quit').evaluate().isNotEmpty;
      expect(hasEndOptions, isTrue);
    });

    testWidgets('quits game mid-match', (tester) async {
      await startGame(tester);

      await tapCell(tester, 4);
      await settle(tester);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await settle(tester);
      expect(find.byIcon(Icons.exit_to_app), findsOneWidget);

      await tester.tap(find.text('Confirm'));
      await settle(tester);

      expect(find.byType(GradientButton), findsOneWidget);
    });

    testWidgets('restarts game mid-round', (tester) async {
      await startGame(tester);

      await tapCell(tester, 0);
      await settle(tester);

      await tester.tap(find.byIcon(Icons.refresh));
      await settle(tester);

      await tester.tap(find.text('Confirm'));
      await settle(tester);

      expect(find.text('1/3'), findsOneWidget);
    });

    testWidgets('changes number of rounds', (tester) async {
      await tester.pumpWidget(await createTestApp());
      await settle(tester);

      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await settle(tester);
      expect(find.text('4'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await settle(tester);
      expect(find.text('3'), findsOneWidget);
    });
  });
}

/// Finder for victory dialog (any result emoji).
Finder findVictoryDialog() {
  return find.byWidgetPredicate((widget) {
    if (widget is Text) {
      final text = widget.data ?? '';
      return text == '🏆' || text == '🦉' || text == '🤝';
    }
    return false;
  });
}
