/// Unified test app wrapper for integration tests.
///
/// Supports both mock auth (fast tests) and Firebase Emulator (E2E tests).
library;

import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_feature/tictactoe_feature.dart';
import 'package:user_domain/user_domain.dart' as domain;
import 'package:user_feature/user_feature.dart';
import 'package:xoapp/firebase_options.dart';
import 'package:xoapp/main.dart' show XoApp;
import 'package:xoapp/src/routing/app_router.dart';
import 'package:xoapp/src/routing/game_navigator_impl.dart';
import 'package:xoapp/src/routing/user_navigator_impl.dart';

bool _firebaseInitialized = false;

/// Mock user for testing without Firebase.
final _mockUser = domain.User(
  uid: 'test-uid',
  name: 'Test Player',
  email: 'test@example.com',
  createdAt: DateTime(2024, 1, 1),
);

/// Returns the correct emulator host based on the platform.
String _getEmulatorHost() {
  if (kIsWeb) return '127.0.0.1';
  if (Platform.isAndroid) return '10.0.2.2';
  return '127.0.0.1';
}

/// Creates a test app for integration testing.
///
/// [useFirebase] - Set to true for E2E tests with Firebase Emulator.
/// [initialRoute] - Override the initial route (default: /home for mock, /welcome for Firebase).
Future<Widget> createTestApp({
  bool useFirebase = false,
  String? initialRoute,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  if (useFirebase) {
    await _initFirebaseEmulator();
  }

  final overrides = [
    sharedPreferencesProvider.overrideWithValue(prefs),
    // Navigator overrides (required by XoApp)
    gameNavigatorProvider.overrideWith(
      (ref) => GameNavigatorImpl(ref.watch(appRouterProvider)),
    ),
    userNavigatorProvider.overrideWith(
      (ref) => UserNavigatorImpl(ref.watch(appRouterProvider)),
    ),
    playerNameProvider.overrideWith(
      (ref) => ref.watch(userViewModelProvider.select((u) => u.value?.name ?? '')),
    ),
  ];

  if (!useFirebase) {
    // Mock auth for fast tests
    overrides.addAll([
      userViewModelProvider.overrideWith(_MockUserViewModel.new),
      authViewModelProvider.overrideWith(_MockAuthViewModel.new),
    ]);
  }

  if (initialRoute != null) {
    overrides.add(
      appRouterProvider.overrideWith((ref) {
        final router = appRouter(ref);
        router.go(initialRoute);
        return router;
      }),
    );
  }

  return ProviderScope(
    overrides: overrides,
    child: const XoApp(),
  );
}

Future<void> _initFirebaseEmulator() async {
  if (_firebaseInitialized) {
    await FirebaseAuth.instance.signOut();
    return;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final host = _getEmulatorHost();
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);

  _firebaseInitialized = true;
}

/// Mock UserViewModel that returns a test user immediately.
class _MockUserViewModel extends UserViewModel {
  @override
  Future<domain.User?> build() async => _mockUser;
}

/// Mock AuthViewModel that returns authenticated state immediately.
class _MockAuthViewModel extends AuthViewModel {
  @override
  Stream<domain.AuthUser?> build() {
    return Stream.value(
      const domain.AuthUser(uid: 'test-uid', email: 'test@example.com'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Test Helpers
// ═══════════════════════════════════════════════════════════════════════════

/// Waits for a widget to appear, returns true if found before timeout.
///
/// More efficient than fixed delays - returns immediately when widget is found.
Future<bool> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
  Duration pollInterval = const Duration(milliseconds: 100),
}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(pollInterval);
    if (finder.evaluate().isNotEmpty) return true;
  }
  return false;
}

/// Waits for a condition to be true, returns true if condition met before timeout.
Future<bool> waitUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
  Duration pollInterval = const Duration(milliseconds: 100),
}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(pollInterval);
    if (condition()) return true;
  }
  return false;
}

/// Pumps frames to let async operations and animations settle.
///
/// Use [waitFor] when waiting for a specific widget.
/// Use this when you just need to wait for navigation/animations.
///
/// Note: Uses fixed frame pumping instead of pumpAndSettle to avoid
/// timeouts with infinite animations (loaders, etc.).
Future<void> settle(
  WidgetTester tester, {
  int frames = 20,
  Duration interval = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(interval);
  }
}

/// Pumps a fixed number of frames (legacy helper, prefer [waitFor] or [settle]).
Future<void> pumpFrames(WidgetTester tester, [int count = 10]) async {
  for (var i = 0; i < count; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Waits for any of the given finders to appear.
Future<bool> waitForAny(
  WidgetTester tester,
  List<Finder> finders, {
  Duration timeout = const Duration(seconds: 10),
  Duration pollInterval = const Duration(milliseconds: 100),
}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(pollInterval);
    for (final finder in finders) {
      if (finder.evaluate().isNotEmpty) return true;
    }
  }
  return false;
}
