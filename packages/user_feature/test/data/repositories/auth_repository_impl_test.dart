/// Tests for [AuthRepositoryImpl] Firebase Auth integration.
///
/// Tests cover:
/// - Current user state (signed in/out)
/// - Auth state stream mapping (Firebase User → AuthUser)
/// - Sign in/up/out operations
/// - Password reset
///
/// Error mapping tested:
/// - FirebaseAuthException codes → user-friendly messages
/// - [SocketException]/[TimeoutException] → [NetworkException]
/// - Unknown errors → [UnknownException]
///
/// Note: Auth use cases (SignInUseCase, etc.) are not tested separately
/// as they are trivial passthroughs to this repository.
library;

import 'dart:async';
import 'dart:io';

import 'package:common/common.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/data/repositories/auth_repository_impl.dart';

import '../../mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    repository = AuthRepositoryImpl(mockFirebaseAuth);
  });

  MockUserCredential mockSuccessCredential(String uid, String email) {
    final mockUser = MockFirebaseUser();
    final mockCredential = MockUserCredential();
    when(() => mockUser.uid).thenReturn(uid);
    when(() => mockUser.email).thenReturn(email);
    when(() => mockCredential.user).thenReturn(mockUser);
    return mockCredential;
  }

  group('AuthRepositoryImpl', () {
    group('currentUser', () {
      test('returns null when not signed in', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);
        expect(repository.currentUser, isNull);
      });

      test('returns AuthUser when signed in', () {
        final mockUser = MockFirebaseUser();
        when(() => mockUser.uid).thenReturn('uid123');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final user = repository.currentUser;

        expect(user, isNotNull);
        expect(user!.uid, equals('uid123'));
        expect(user.email, equals('test@example.com'));
      });
    });

    group('authStateChanges', () {
      test('maps Firebase user to AuthUser', () async {
        final mockUser = MockFirebaseUser();
        when(() => mockUser.uid).thenReturn('uid123');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockFirebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(mockUser));

        await expectLater(
          repository.authStateChanges,
          emits(isA<AuthUser>().having((u) => u.uid, 'uid', 'uid123')),
        );
      });

      test('emits null when signed out', () async {
        when(() => mockFirebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(null));

        await expectLater(repository.authStateChanges, emits(isNull));
      });
    });

    group('signIn', () {
      test('returns AuthUser on success', () async {
        final credential = mockSuccessCredential('uid123', 'test@example.com');
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => credential);

        final result = await repository.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'pass',
        );

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull!.uid, equals('uid123'));
      });
    });

    group('signUp', () {
      test('returns AuthUser on success', () async {
        final credential = mockSuccessCredential('uid123', 'test@example.com');
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => credential);

        final result = await repository.signUpWithEmailAndPassword(
          email: 'test@example.com',
          password: 'pass',
        );

        expect(result.dataOrNull, isNotNull);
        expect(result.dataOrNull!.uid, equals('uid123'));
        expect(result.dataOrNull!.email, equals('test@example.com'));
      });
    });

    group('signOut', () {
      test('returns success', () async {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        final result = await repository.signOut();
        expect(result.isSuccess, isTrue);
      });
    });

    group('resetPassword', () {
      test('returns success', () async {
        when(() => mockFirebaseAuth.sendPasswordResetEmail(email: any(named: 'email')))
            .thenAnswer((_) async {});
        final result = await repository.resetPassword(email: 'test@example.com');
        expect(result.isSuccess, isTrue);
      });
    });

    group('error mapping', () {
      Future<Result<AuthUser>> signInWithError(Object error) {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(error);
        return repository.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'pass',
        );
      }

      test('maps FirebaseAuthException to AuthException with correct message', () async {
        final errorCases = {
          'wrong-password': 'Incorrect password',
          'user-not-found': 'No account found with this email',
          'email-already-in-use': 'An account already exists with this email',
          'invalid-credential': 'Invalid email or password',
        };

        for (final entry in errorCases.entries) {
          reset(mockFirebaseAuth);
          final result = await signInWithError(
            fb.FirebaseAuthException(code: entry.key, message: 'Firebase msg'),
          );

          final exception = result.exceptionOrNull as AuthException;
          expect(exception.code, equals(entry.key), reason: 'Code for ${entry.key}');
          expect(exception.message, equals(entry.value), reason: 'Message for ${entry.key}');
        }
      });

      test('maps unknown Firebase code to default message', () async {
        final result = await signInWithError(
          fb.FirebaseAuthException(code: 'unknown-code', message: 'Firebase message'),
        );

        final exception = result.exceptionOrNull as AuthException;
        expect(exception.message, equals('Firebase message'));
      });

      test('maps SocketException to NetworkException', () async {
        final result = await signInWithError(const SocketException(''));
        expect(result.exceptionOrNull, isA<NetworkException>());
      });

      test('maps TimeoutException to NetworkException', () async {
        final result = await signInWithError(TimeoutException(''));
        expect(result.exceptionOrNull, isA<NetworkException>());
      });

      test('maps unknown errors to UnknownException', () async {
        final result = await signInWithError(Exception('unexpected'));
        expect(result.exceptionOrNull, isA<UnknownException>());
      });
    });
  });
}
