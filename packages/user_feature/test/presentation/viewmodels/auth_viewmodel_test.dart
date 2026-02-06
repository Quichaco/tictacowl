/// Tests for [AuthViewModel] - authentication operations.
///
/// Verifies the ViewModel correctly:
/// - Handles sign in with email trimming
/// - Handles sign up with email trimming
/// - Handles sign out
/// - Handles password reset
///
/// Note: Stream-based auth state tests are omitted due to async timing
/// complexity. The stream behavior is tested indirectly through repository tests.
///
/// Uses mocked use cases and a real ProviderContainer.
library;

import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/presentation/viewmodels/auth_viewmodel.dart';
import 'package:user_feature/src/providers/usecase_providers.dart';

// Mocks
class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockWatchAuthStateUseCase extends Mock implements WatchAuthStateUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  late ProviderContainer container;
  late MockSignInUseCase mockSignIn;
  late MockSignUpUseCase mockSignUp;
  late MockSignOutUseCase mockSignOut;
  late MockWatchAuthStateUseCase mockWatchAuthState;
  late MockResetPasswordUseCase mockResetPassword;

  const testAuthUser = AuthUser(uid: 'test-uid', email: 'test@example.com');

  setUp(() {
    mockSignIn = MockSignInUseCase();
    mockSignUp = MockSignUpUseCase();
    mockSignOut = MockSignOutUseCase();
    mockWatchAuthState = MockWatchAuthStateUseCase();
    mockResetPassword = MockResetPasswordUseCase();

    // Setup a simple stream that emits null (not signed in)
    when(() => mockWatchAuthState.call())
        .thenAnswer((_) => Stream.value(null));

    container = ProviderContainer(
      overrides: [
        signInUseCaseProvider.overrideWith((ref) => mockSignIn),
        signUpUseCaseProvider.overrideWith((ref) => mockSignUp),
        signOutUseCaseProvider.overrideWith((ref) => mockSignOut),
        watchAuthStateUseCaseProvider.overrideWith((ref) => mockWatchAuthState),
        resetPasswordUseCaseProvider.overrideWith((ref) => mockResetPassword),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewModel', () {
    group('signIn', () {
      test('calls use case with trimmed email', () async {
        when(() => mockSignIn.call(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Result.success(testAuthUser));

        final notifier = container.read(authViewModelProvider.notifier);
        await notifier.signIn(
          email: '  test@example.com  ',
          password: 'password123',
        );

        verify(() => mockSignIn.call(
              email: 'test@example.com',
              password: 'password123',
            )).called(1);
      });

      test('returns success result on successful sign in', () async {
        when(() => mockSignIn.call(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Result.success(testAuthUser));

        final notifier = container.read(authViewModelProvider.notifier);
        final result = await notifier.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(testAuthUser));
      });

      test('returns failure result on sign in error', () async {
        const error = AuthException(code: 'invalid-credential', message: 'Invalid credentials');
        when(() => mockSignIn.call(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Result.failure(error));

        final notifier = container.read(authViewModelProvider.notifier);
        final result = await notifier.signIn(
          email: 'test@example.com',
          password: 'wrong-password',
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('signUp', () {
      test('calls use case with trimmed email', () async {
        when(() => mockSignUp.call(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Result.success(testAuthUser));

        final notifier = container.read(authViewModelProvider.notifier);
        await notifier.signUp(
          email: '  newuser@example.com  ',
          password: 'password123',
        );

        verify(() => mockSignUp.call(
              email: 'newuser@example.com',
              password: 'password123',
            )).called(1);
      });

      test('returns success result on successful sign up', () async {
        when(() => mockSignUp.call(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Result.success(testAuthUser));

        final notifier = container.read(authViewModelProvider.notifier);
        final result = await notifier.signUp(
          email: 'newuser@example.com',
          password: 'password123',
        );

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(testAuthUser));
      });

      test('returns failure result on sign up error', () async {
        const error = AuthException(code: 'email-already-in-use', message: 'Email already exists');
        when(() => mockSignUp.call(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Result.failure(error));

        final notifier = container.read(authViewModelProvider.notifier);
        final result = await notifier.signUp(
          email: 'existing@example.com',
          password: 'password123',
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('signOut', () {
      test('calls sign out use case', () async {
        when(() => mockSignOut.call())
            .thenAnswer((_) async => const Result.success(null));

        final notifier = container.read(authViewModelProvider.notifier);
        await notifier.signOut();

        verify(() => mockSignOut.call()).called(1);
      });

      test('returns success result on successful sign out', () async {
        when(() => mockSignOut.call())
            .thenAnswer((_) async => const Result.success(null));

        final notifier = container.read(authViewModelProvider.notifier);
        final result = await notifier.signOut();

        expect(result.isSuccess, isTrue);
      });
    });

    group('resetPassword', () {
      test('calls use case with trimmed email', () async {
        when(() => mockResetPassword.call(email: any(named: 'email')))
            .thenAnswer((_) async => const Result.success(null));

        final notifier = container.read(authViewModelProvider.notifier);
        await notifier.resetPassword(email: '  user@example.com  ');

        verify(() => mockResetPassword.call(email: 'user@example.com')).called(1);
      });

      test('returns success result on successful password reset', () async {
        when(() => mockResetPassword.call(email: any(named: 'email')))
            .thenAnswer((_) async => const Result.success(null));

        final notifier = container.read(authViewModelProvider.notifier);
        final result = await notifier.resetPassword(email: 'user@example.com');

        expect(result.isSuccess, isTrue);
      });

      test('returns failure result on error', () async {
        const error = AuthException(code: 'user-not-found', message: 'User not found');
        when(() => mockResetPassword.call(email: any(named: 'email')))
            .thenAnswer((_) async => const Result.failure(error));

        final notifier = container.read(authViewModelProvider.notifier);
        final result = await notifier.resetPassword(email: 'nonexistent@example.com');

        expect(result.isFailure, isTrue);
      });
    });
  });
}
