import 'dart:async';
import 'dart:io';

import 'package:common/common.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUser(uid: user.uid, email: user.email ?? '');
    });
  }

  @override
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return AuthUser(uid: user.uid, email: user.email ?? '');
  }

  @override
  Future<Result<AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) {
        return const Result.failure(
          AuthException(code: 'no-user', message: 'Authentication failed'),
        );
      }
      return Result.success(AuthUser(uid: user.uid, email: user.email ?? email));
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } on TimeoutException {
      return Result.failure(const NetworkException(message: 'Request timed out'));
    } on SocketException {
      return Result.failure(const NetworkException(message: 'No internet connection'));
    } catch (e) {
      return Result.failure(UnknownException(error: e));
    }
  }

  @override
  Future<Result<AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) {
        return const Result.failure(
          AuthException(code: 'no-user', message: 'Account creation failed'),
        );
      }
      return Result.success(AuthUser(uid: user.uid, email: user.email ?? email));
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } on TimeoutException {
      return Result.failure(const NetworkException(message: 'Request timed out'));
    } on SocketException {
      return Result.failure(const NetworkException(message: 'No internet connection'));
    } catch (e) {
      return Result.failure(UnknownException(error: e));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Result.success(null);
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } catch (e) {
      return Result.failure(UnknownException(error: e));
    }
  }

  @override
  Future<Result<void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth
          .sendPasswordResetEmail(email: email);
      return const Result.success(null);
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } on TimeoutException {
      return Result.failure(const NetworkException(message: 'Request timed out'));
    } on SocketException {
      return Result.failure(const NetworkException(message: 'No internet connection'));
    } catch (e) {
      return Result.failure(UnknownException(error: e));
    }
  }

  AuthException _mapFirebaseAuthException(fb.FirebaseAuthException e) {
    final message = switch (e.code) {
      'invalid-email' => 'Invalid email address',
      'user-disabled' => 'This account has been disabled',
      'user-not-found' => 'No account found with this email',
      'wrong-password' => 'Incorrect password',
      'invalid-credential' => 'Invalid email or password',
      'email-already-in-use' => 'An account already exists with this email',
      'weak-password' => 'Password is too weak',
      'operation-not-allowed' => 'Operation not allowed',
      'too-many-requests' => 'Too many attempts. Please try again later',
      'network-request-failed' => 'Network error. Check your connection',
      _ => e.message ?? 'Authentication error',
    };
    return AuthException(code: e.code, message: message);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(fb.FirebaseAuth.instance);
}
