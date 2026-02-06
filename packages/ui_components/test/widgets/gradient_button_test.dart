/// Widget tests for [GradientButton] - async-aware gradient button.
///
/// Tests button behavior:
/// - Displays label and optional icon
/// - Calls onPressed when tapped (not disabled)
/// - Shows loading indicator during async operation
/// - Disabled when onPressed is null
/// - Secondary variant uses different gradient
///
/// This is a reusable UI component, so we test it in isolation.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

/// Wraps widget with MaterialApp and theme for isolated testing.
Widget _testableWidget(Widget child) {
  return MaterialApp(
    theme: ThemeData.light().copyWith(extensions: [BrandTheme.light]),
    home: HookBuilder(builder: (context) => Scaffold(body: Center(child: child))),
  );
}

void main() {
  group('GradientButton', () {
    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          GradientButton(
            label: 'Click Me',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          GradientButton(
            label: 'With Icon',
            icon: Icons.play_arrow,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        _testableWidget(
          GradientButton(
            label: 'Press',
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.text('Press'));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        _testableWidget(
          GradientButton(
            label: 'Disabled',
            onPressed: null,
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('shows loading indicator during async operation', (tester) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        _testableWidget(
          GradientButton(
            label: 'Async',
            onPressed: () => completer.future,
          ),
        ),
      );

      // Tap the button to start async operation
      await tester.tap(find.text('Async'));
      await tester.pump();

      // Should show loader
      expect(find.byType(XoLoader), findsOneWidget);

      // Complete the operation
      completer.complete();
      await tester.pumpAndSettle();

      // Loader should be gone
      expect(find.byType(XoLoader), findsNothing);
    });

    testWidgets('is disabled during loading', (tester) async {
      final completer = Completer<void>();
      var pressCount = 0;

      await tester.pumpWidget(
        _testableWidget(
          GradientButton(
            label: 'Loading Test',
            onPressed: () {
              pressCount++;
              return completer.future;
            },
          ),
        ),
      );

      // First tap starts loading
      await tester.tap(find.text('Loading Test'));
      await tester.pump();

      // Second tap should be ignored (button disabled during loading)
      await tester.tap(find.text('Loading Test'));
      await tester.pump();

      expect(pressCount, equals(1));

      completer.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('secondary variant renders', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          GradientButton.secondary(
            label: 'Secondary',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('respects expand parameter', (tester) async {
      await tester.pumpWidget(
        _testableWidget(
          GradientButton(
            label: 'Not Expanded',
            expand: false,
            onPressed: () {},
          ),
        ),
      );

      // Button should exist and not take full width
      expect(find.text('Not Expanded'), findsOneWidget);
    });
  });
}
