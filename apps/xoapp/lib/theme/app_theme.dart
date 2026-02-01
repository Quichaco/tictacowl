import 'package:flutter/material.dart';
import 'package:xoapp/theme/app_colors.dart';
import 'package:xoapp/theme/app_radius.dart';
import 'package:xoapp/theme/app_spacing.dart';

abstract class AppTheme {
  static final _inputTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: AppRadius.input),
    enabledBorder: OutlineInputBorder(borderRadius: AppRadius.input),
    focusedBorder: OutlineInputBorder(borderRadius: AppRadius.input),
    errorBorder: OutlineInputBorder(borderRadius: AppRadius.input),
    focusedErrorBorder: OutlineInputBorder(borderRadius: AppRadius.input),
    disabledBorder: OutlineInputBorder(borderRadius: AppRadius.input),
    filled: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
  );

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
        useMaterial3: true,
        inputDecorationTheme: _inputTheme,
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        inputDecorationTheme: _inputTheme,
      );
}
