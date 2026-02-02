import 'package:flutter/material.dart';
import 'package:xoapp/l10n/gen/app_localizations.dart';

extension ThemeModeExtensions on ThemeMode {
  String label(AppLocalizations l10n) => switch (this) {
        ThemeMode.light => l10n.themeLight,
        ThemeMode.dark => l10n.themeDark,
        ThemeMode.system => l10n.themeSystem,
      };

  IconData get icon => switch (this) {
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
        ThemeMode.system => Icons.settings_brightness,
      };
}
