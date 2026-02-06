/// Tests for [AppPreferencesRepositoryImpl] - app-level settings persistence.
///
/// Uses [SharedPreferences.setMockInitialValues] for testing without
/// actual device storage.
///
/// Tested settings:
/// - [ThemeMode]: light/dark/system preference
/// - [Locale]: User's language preference (nullable = system default)
///
/// Edge cases:
/// - Invalid stored values fall back to defaults
/// - Null locale removes the preference (uses system locale)
///
/// Note: ViewModels (ThemeViewModel, LocaleViewModel) are not tested
/// as they are thin wrappers that just call this repository.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoapp/src/data/repositories/app_preferences_repository_impl.dart';

void main() {
  late SharedPreferences prefs;
  late AppPreferencesRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = AppPreferencesRepositoryImpl(prefs);
  });

  group('AppPreferencesRepositoryImpl', () {
    group('getThemeMode', () {
      test('returns system by default', () {
        expect(repository.getThemeMode(), equals(ThemeMode.system));
      });

      test('returns saved theme mode', () async {
        await prefs.setString('theme_mode', 'dark');
        repository = AppPreferencesRepositoryImpl(prefs);

        expect(repository.getThemeMode(), equals(ThemeMode.dark));
      });

      test('returns system for invalid theme string', () async {
        await prefs.setString('theme_mode', 'invalid_theme');
        repository = AppPreferencesRepositoryImpl(prefs);

        expect(repository.getThemeMode(), equals(ThemeMode.system));
      });
    });

    group('setThemeMode', () {
      test('saves theme mode to preferences', () {
        repository.setThemeMode(ThemeMode.dark);

        expect(prefs.getString('theme_mode'), equals('dark'));
      });

      test('saved theme mode can be retrieved', () {
        repository.setThemeMode(ThemeMode.light);

        expect(repository.getThemeMode(), equals(ThemeMode.light));
      });
    });

    group('getLocale', () {
      test('returns null by default', () {
        expect(repository.getLocale(), isNull);
      });

      test('returns saved locale', () async {
        await prefs.setString('locale', 'fr');
        repository = AppPreferencesRepositoryImpl(prefs);

        expect(repository.getLocale(), equals(const Locale('fr')));
      });
    });

    group('setLocale', () {
      test('saves locale to preferences', () {
        repository.setLocale(const Locale('fr'));

        expect(prefs.getString('locale'), equals('fr'));
      });

      test('removes locale when set to null', () async {
        await prefs.setString('locale', 'fr');
        repository = AppPreferencesRepositoryImpl(prefs);

        repository.setLocale(null);

        expect(prefs.getString('locale'), isNull);
      });

      test('saved locale can be retrieved', () {
        repository.setLocale(const Locale('es'));

        expect(repository.getLocale(), equals(const Locale('es')));
      });
    });
  });
}
