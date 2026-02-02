import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

abstract class AppTheme {
  static final _inputTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: AppRadius.input),
    filled: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
  );

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.purple,
        ).copyWith(
          secondary: AppColors.pink,
          onPrimary: Colors.white,
        ),
        inputDecorationTheme: _inputTheme,
        extensions: const [BrandTheme.light],
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.purple,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: AppColors.pink,
          onPrimary: Colors.white,
        ),
        inputDecorationTheme: _inputTheme,
        extensions: const [BrandTheme.dark],
      );
}
