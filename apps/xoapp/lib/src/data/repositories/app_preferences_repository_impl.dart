import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xoapp/src/domain/repositories/app_preferences_repository.dart';

part 'app_preferences_repository_impl.g.dart';

class AppPreferencesRepositoryImpl implements AppPreferencesRepository {
  AppPreferencesRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';

  @override
  ThemeMode getThemeMode() {
    final raw = _prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  void setThemeMode(ThemeMode mode) {
    _prefs.setString(_themeKey, mode.name);
  }

  @override
  Locale? getLocale() {
    final raw = _prefs.getString(_localeKey);
    return raw != null ? Locale(raw) : null;
  }

  @override
  void setLocale(Locale? locale) {
    if (locale == null) {
      _prefs.remove(_localeKey);
    } else {
      _prefs.setString(_localeKey, locale.languageCode);
    }
  }
}

@Riverpod(keepAlive: true)
AppPreferencesRepository appPreferencesRepository(Ref ref) {
  return AppPreferencesRepositoryImpl(ref.watch(sharedPreferencesProvider));
}
