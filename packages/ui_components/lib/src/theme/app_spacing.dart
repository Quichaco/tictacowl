import 'package:flutter/widgets.dart';

abstract class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 48;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const EdgeInsets screenHPadding = EdgeInsets.symmetric(
    horizontal: md,
  );
}
