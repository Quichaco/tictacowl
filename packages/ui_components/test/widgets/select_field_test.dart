/// Widget tests for [SelectField] - bottom sheet selector.
///
/// Tests selector behavior:
/// - Displays selected value with label
/// - Shows icon when iconOf provided
/// - Opens bottom sheet on tap
/// - Calls onSelected when option is chosen
/// - Shows check mark on selected option
///
/// This is a reusable UI component, so we test it in isolation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

/// Wraps widget with MaterialApp and theme for isolated testing.
Widget _testableWidget(Widget child) {
  return MaterialApp(
    theme: ThemeData.light().copyWith(extensions: [BrandTheme.light]),
    home: Scaffold(body: child),
  );
}

enum TestOption { option1, option2, option3 }

void main() {
  group('SelectField', () {
    testWidgets('displays selected value label', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          SelectField<TestOption>(
            title: 'Select Option',
            values: TestOption.values,
            selected: TestOption.option1,
            labelOf: (o) => o.name.toUpperCase(),
            onSelected: (_) {},
          ),
        ),
      );

      expect(find.text('OPTION1'), findsOneWidget);
    });

    testWidgets('displays chevron icon', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          SelectField<TestOption>(
            title: 'Select Option',
            values: TestOption.values,
            selected: TestOption.option1,
            labelOf: (o) => o.name,
            onSelected: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('displays leading icon when iconOf provided', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          SelectField<TestOption>(
            title: 'Select Option',
            values: TestOption.values,
            selected: TestOption.option1,
            labelOf: (o) => o.name,
            iconOf: (_) => Icons.star,
            onSelected: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('opens bottom sheet on tap', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          SelectField<TestOption>(
            title: 'Select Option',
            values: TestOption.values,
            selected: TestOption.option1,
            labelOf: (o) => o.name,
            onSelected: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Should show the title in the bottom sheet
      expect(find.text('Select Option'), findsOneWidget);

      // Should show all options (may appear twice - in list tile and bottom sheet)
      expect(find.text('option1'), findsWidgets);
      expect(find.text('option2'), findsOneWidget);
      expect(find.text('option3'), findsOneWidget);
    });

    testWidgets('shows check mark on selected option in sheet', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          SelectField<TestOption>(
            title: 'Select Option',
            values: TestOption.values,
            selected: TestOption.option2,
            labelOf: (o) => o.name,
            onSelected: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Should show check icon for selected option
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onSelected when option is tapped', (tester) async {
      TestOption? selectedValue;

      await tester.pumpWidget(
        _testableWidget(
          SelectField<TestOption>(
            title: 'Select Option',
            values: TestOption.values,
            selected: TestOption.option1,
            labelOf: (o) => o.name,
            onSelected: (v) => selectedValue = v,
          ),
        ),
      );

      // Open the sheet
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Tap option3
      await tester.tap(find.text('option3'));
      await tester.pumpAndSettle();

      expect(selectedValue, equals(TestOption.option3));
    });

    testWidgets('closes sheet after selection', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          SelectField<TestOption>(
            title: 'Select Option',
            values: TestOption.values,
            selected: TestOption.option1,
            labelOf: (o) => o.name,
            onSelected: (_) {},
          ),
        ),
      );

      // Open the sheet
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Tap an option
      await tester.tap(find.text('option2'));
      await tester.pumpAndSettle();

      // Sheet should be closed (title no longer visible in bottom sheet context)
      // The original ListTile should still be visible
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('works with different value types', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        _testableWidget(
          SelectField<String>(
            title: 'Select String',
            values: const ['Alpha', 'Beta', 'Gamma'],
            selected: 'Alpha',
            labelOf: (s) => s,
            onSelected: (v) => selectedValue = v,
          ),
        ),
      );

      expect(find.text('Alpha'), findsOneWidget);

      // Open and select
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gamma'));
      await tester.pumpAndSettle();

      expect(selectedValue, equals('Gamma'));
    });
  });
}
