import 'package:common/common.dart';
import 'package:user_domain/src/models/auth_user.dart';

export 'package:user_domain/src/models/auth_user.dart';

/// Repository interface for authentication operations.
abstract class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  AuthUser? get currentUser;

  Future<Result<AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<void>> signOut();

  Future<Result<void>> resetPassword({required String email});
}
