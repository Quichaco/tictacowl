import 'package:flutter/widgets.dart';

abstract class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  static const BorderRadius input = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius button = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
}
