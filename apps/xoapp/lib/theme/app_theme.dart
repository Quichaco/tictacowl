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

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.actionStart,
    ).copyWith(
      secondary: AppColors.playerOStart,
      onPrimary: Colors.white,
      surface: const Color(0xFFFFFBF7),
      surfaceContainerLow: const Color(0xFFFAF5EF),
      surfaceContainer: const Color(0xFFF4EBE0),
      outline: const Color(0xFFE0D5C8),
    );

    return ThemeData(
      colorScheme: colorScheme,
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      inputDecorationTheme: _inputTheme,
      extensions: const [BrandTheme.light],
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.actionStart,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: AppColors.playerOStart,
      onPrimary: Colors.white,
      surface: const Color(0xFF1A1614),
      surfaceContainerLow: const Color(0xFF231E1A),
      surfaceContainer: const Color(0xFF2E2720),
      outline: const Color(0xFF3D352C),
    );

    return ThemeData(
      colorScheme: colorScheme,
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      inputDecorationTheme: _inputTheme,
      extensions: const [BrandTheme.dark],
    );
  }
}
