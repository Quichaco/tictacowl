import 'package:flutter/material.dart';
import 'package:ui_components/src/theme/app_colors.dart';

class BrandTheme extends ThemeExtension<BrandTheme> {
  const BrandTheme({
    required this.actionGradient,
    required this.secondaryGradient,
  });

  final LinearGradient actionGradient;
  final LinearGradient secondaryGradient;

  static const light = BrandTheme(
    actionGradient: LinearGradient(
      colors: [AppColors.purple, AppColors.pink],
    ),
    secondaryGradient: LinearGradient(
      colors: [AppColors.teal, AppColors.blue],
    ),
  );

  static const dark = BrandTheme(
    actionGradient: LinearGradient(
      colors: [AppColors.purple, AppColors.pink],
    ),
    secondaryGradient: LinearGradient(
      colors: [AppColors.teal, AppColors.blue],
    ),
  );

  @override
  BrandTheme copyWith({
    LinearGradient? actionGradient,
    LinearGradient? secondaryGradient,
  }) {
    return BrandTheme(
      actionGradient: actionGradient ?? this.actionGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
    );
  }

  @override
  BrandTheme lerp(BrandTheme? other, double t) {
    if (other == null) return this;
    return BrandTheme(
      actionGradient:
          LinearGradient.lerp(actionGradient, other.actionGradient, t)!,
      secondaryGradient:
          LinearGradient.lerp(secondaryGradient, other.secondaryGradient, t)!,
    );
  }
}
