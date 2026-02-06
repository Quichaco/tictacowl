/// Tests for [ThemeViewModel] - theme mode state management.
///
/// Verifies the ViewModel correctly:
/// - Initializes from saved preferences
/// - Updates theme mode and persists to repository
///
/// Uses mock SharedPreferences and a real ProviderContainer.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xoapp/src/presentation/viewmodels/theme_viewmodel.dart';
import 'package:core/core.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ThemeViewModel', () {
    group('build (initialization)', () {
      test('returns system by default', () {
        final themeMode = container.read(themeViewModelProvider);

        expect(themeMode, equals(ThemeMode.system));
      });

      test('returns saved theme mode from preferences', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
        final prefs = await SharedPreferences.getInstance();
        container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        final themeMode = container.read(themeViewModelProvider);

        expect(themeMode, equals(ThemeMode.dark));
      });

      test('returns light when saved', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
        final prefs = await SharedPreferences.getInstance();
        container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        final themeMode = container.read(themeViewModelProvider);

        expect(themeMode, equals(ThemeMode.light));
      });
    });

    group('setThemeMode', () {
      test('updates state with new theme mode', () {
        final notifier = container.read(themeViewModelProvider.notifier);

        notifier.setThemeMode(ThemeMode.dark);

        expect(container.read(themeViewModelProvider), equals(ThemeMode.dark));
      });

      test('persists theme mode to repository', () async {
        final notifier = container.read(themeViewModelProvider.notifier);

        notifier.setThemeMode(ThemeMode.light);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('theme_mode'), equals('light'));
      });

      test('allows changing theme mode multiple times', () {
        final notifier = container.read(themeViewModelProvider.notifier);

        notifier.setThemeMode(ThemeMode.dark);
        expect(container.read(themeViewModelProvider), equals(ThemeMode.dark));

        notifier.setThemeMode(ThemeMode.light);
        expect(container.read(themeViewModelProvider), equals(ThemeMode.light));

        notifier.setThemeMode(ThemeMode.system);
        expect(container.read(themeViewModelProvider), equals(ThemeMode.system));
      });

      test('setting same theme mode is idempotent', () async {
        final notifier = container.read(themeViewModelProvider.notifier);

        notifier.setThemeMode(ThemeMode.dark);
        notifier.setThemeMode(ThemeMode.dark);
        notifier.setThemeMode(ThemeMode.dark);

        expect(container.read(themeViewModelProvider), equals(ThemeMode.dark));
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('theme_mode'), equals('dark'));
      });
    });

    group('all theme modes', () {
      test('supports all ThemeMode values', () {
        final notifier = container.read(themeViewModelProvider.notifier);

        for (final mode in ThemeMode.values) {
          notifier.setThemeMode(mode);
          expect(container.read(themeViewModelProvider), equals(mode));
        }
      });
    });
  });
}
