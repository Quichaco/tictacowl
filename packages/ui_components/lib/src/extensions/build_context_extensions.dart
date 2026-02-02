import 'package:flutter/material.dart';
import 'package:ui_components/src/theme/app_brand.dart';

extension BuildContextThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  BrandTheme get brand => theme.extension<BrandTheme>()!;
}
