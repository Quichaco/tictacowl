/// Tests for [LocaleViewModel] - locale state management.
///
/// Verifies the ViewModel correctly:
/// - Initializes from saved preferences (null = system default)
/// - Updates locale and persists to repository
/// - Supports null locale (system default)
///
/// Uses mock SharedPreferences and a real ProviderContainer.
library;

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xoapp/src/presentation/viewmodels/locale_viewmodel.dart';
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

  group('LocaleViewModel', () {
    group('build (initialization)', () {
      test('returns null by default (system locale)', () {
        final locale = container.read(localeViewModelProvider);

        expect(locale, isNull);
      });

      test('returns saved locale from preferences', () async {
        SharedPreferences.setMockInitialValues({'locale': 'fr'});
        final prefs = await SharedPreferences.getInstance();
        container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        final locale = container.read(localeViewModelProvider);

        expect(locale, equals(const Locale('fr')));
      });

      test('returns English locale when saved', () async {
        SharedPreferences.setMockInitialValues({'locale': 'en'});
        final prefs = await SharedPreferences.getInstance();
        container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        final locale = container.read(localeViewModelProvider);

        expect(locale, equals(const Locale('en')));
      });
    });

    group('setLocale', () {
      test('updates state with new locale', () {
        final notifier = container.read(localeViewModelProvider.notifier);

        notifier.setLocale(const Locale('fr'));

        expect(
          container.read(localeViewModelProvider),
          equals(const Locale('fr')),
        );
      });

      test('persists locale to repository', () async {
        final notifier = container.read(localeViewModelProvider.notifier);

        notifier.setLocale(const Locale('fr'));

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('locale'), equals('fr'));
      });

      test('allows setting null to use system locale', () async {
        final notifier = container.read(localeViewModelProvider.notifier);

        // First set a locale
        notifier.setLocale(const Locale('fr'));
        expect(container.read(localeViewModelProvider), isNotNull);

        // Then reset to system default
        notifier.setLocale(null);

        expect(container.read(localeViewModelProvider), isNull);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('locale'), isNull);
      });

      test('allows changing locale multiple times', () {
        final notifier = container.read(localeViewModelProvider.notifier);

        notifier.setLocale(const Locale('fr'));
        expect(
          container.read(localeViewModelProvider),
          equals(const Locale('fr')),
        );

        notifier.setLocale(const Locale('en'));
        expect(
          container.read(localeViewModelProvider),
          equals(const Locale('en')),
        );

        notifier.setLocale(const Locale('es'));
        expect(
          container.read(localeViewModelProvider),
          equals(const Locale('es')),
        );
      });

      test('setting same locale is idempotent', () async {
        final notifier = container.read(localeViewModelProvider.notifier);

        notifier.setLocale(const Locale('fr'));
        notifier.setLocale(const Locale('fr'));
        notifier.setLocale(const Locale('fr'));

        expect(
          container.read(localeViewModelProvider),
          equals(const Locale('fr')),
        );
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('locale'), equals('fr'));
      });
    });

    group('supported locales', () {
      test('supports French locale', () {
        final notifier = container.read(localeViewModelProvider.notifier);

        notifier.setLocale(const Locale('fr'));

        expect(
          container.read(localeViewModelProvider)?.languageCode,
          equals('fr'),
        );
      });

      test('supports English locale', () {
        final notifier = container.read(localeViewModelProvider.notifier);

        notifier.setLocale(const Locale('en'));

        expect(
          container.read(localeViewModelProvider)?.languageCode,
          equals('en'),
        );
      });
    });
  });
}
