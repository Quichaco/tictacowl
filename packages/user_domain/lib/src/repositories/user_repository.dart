import 'package:common/common.dart';
import 'package:user_domain/src/models/user.dart';

/// Repository interface for user profile operations (Firestore).
abstract class UserRepository {
  Future<Result<void>> saveUser(User user);

  Future<Result<User?>> getUser(String uid);
}
