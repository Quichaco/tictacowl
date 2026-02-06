/// Widget tests for [RoundCounter] - numeric stepper control.
///
/// Tests increment/decrement behavior with bounds checking:
/// - Displays current value
/// - + button increments (respects max bound)
/// - - button decrements (respects min bound)
/// - Callbacks are NOT called when at bounds
///
/// This is a reusable UI component, so we test it in isolation from
/// any specific feature.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

/// Wraps widget with MaterialApp and theme for isolated testing.
Widget _testableWidget(Widget child) {
  return MaterialApp(
    theme: ThemeData.light().copyWith(extensions: [BrandTheme.light]),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('RoundCounter', () {
    testWidgets('displays current value', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          RoundCounter(value: 5, onChanged: (_) {}),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('increment button calls onChanged with value + 1', (tester) async {
      int? newValue;

      await tester.pumpWidget(
        _testableWidget(
          RoundCounter(value: 3, onChanged: (v) => newValue = v),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      expect(newValue, equals(4));
    });

    testWidgets('decrement button calls onChanged with value - 1', (tester) async {
      int? newValue;

      await tester.pumpWidget(
        _testableWidget(
          RoundCounter(value: 3, onChanged: (v) => newValue = v),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      expect(newValue, equals(2));
    });

    testWidgets('does not increment beyond max', (tester) async {
      int? newValue;

      await tester.pumpWidget(
        _testableWidget(
          RoundCounter(value: 10, max: 10, onChanged: (v) => newValue = v),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      expect(newValue, isNull);
    });

    testWidgets('does not decrement below min', (tester) async {
      int? newValue;

      await tester.pumpWidget(
        _testableWidget(
          RoundCounter(value: 1, min: 1, onChanged: (v) => newValue = v),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      expect(newValue, isNull);
    });
  });
}
