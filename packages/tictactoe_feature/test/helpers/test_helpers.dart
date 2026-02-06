/// Test utilities for tictactoe_feature widget tests.
///
/// Provides helper functions to wrap widgets with required context
/// (MaterialApp, theme extensions) for isolated widget testing.
library;

import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Wraps a widget with MaterialApp and required theme extensions for testing.
///
/// This is necessary because many widgets use:
/// - `context.colorScheme` - requires MaterialApp
/// - `context.brand` - requires BrandTheme extension
///
/// Example:
/// ```dart
/// await tester.pumpWidget(testableWidget(MyWidget()));
/// ```
Widget testableWidget(Widget child) {
  return MaterialApp(
    theme: ThemeData.light().copyWith(
      extensions: [BrandTheme.light],
    ),
    home: Scaffold(body: child),
  );
}
