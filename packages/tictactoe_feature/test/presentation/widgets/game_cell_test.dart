/// Widget tests for [GameCell] - individual board cell.
///
/// Tests tap behavior and visual state:
/// - Empty cells are tappable and show no symbol
/// - Occupied cells are not tappable and show X/O symbol
///
/// Uses [testableWidget] helper to wrap the widget with required
/// MaterialApp and theme extensions.
///
/// Note: We don't test animations or exact styling - just behavior
/// and presence of key widgets.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_feature/src/presentation/widgets/board/game_cell.dart';
import 'package:ui_components/ui_components.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('GameCell', () {
    testWidgets('calls onTap when empty and tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        testableWidget(
          SizedBox(
            width: 100,
            height: 100,
            child: GameCell(
              symbolType: XoSymbolType.x,
              isEmpty: true,
              gradient: const LinearGradient(colors: [Colors.blue, Colors.blue]),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GameCell));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when not empty', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        testableWidget(
          SizedBox(
            width: 100,
            height: 100,
            child: GameCell(
              symbolType: XoSymbolType.x,
              isEmpty: false,
              gradient: const LinearGradient(colors: [Colors.blue, Colors.blue]),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GameCell));
      expect(tapped, isFalse);
    });

    testWidgets('shows XoSymbol when not empty', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          SizedBox(
            width: 100,
            height: 100,
            child: GameCell(
              symbolType: XoSymbolType.o,
              isEmpty: false,
              gradient: const LinearGradient(colors: [Colors.red, Colors.red]),
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(XoSymbol), findsOneWidget);
    });

    testWidgets('does not show XoSymbol when empty', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          SizedBox(
            width: 100,
            height: 100,
            child: GameCell(
              symbolType: XoSymbolType.x,
              isEmpty: true,
              gradient: const LinearGradient(colors: [Colors.blue, Colors.blue]),
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(XoSymbol), findsNothing);
    });
  });
}
