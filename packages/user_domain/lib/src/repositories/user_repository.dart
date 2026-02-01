import 'package:user_domain/src/models/user.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser();
}
