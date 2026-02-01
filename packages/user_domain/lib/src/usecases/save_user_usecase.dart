import 'package:user_domain/src/models/user.dart';
import 'package:user_domain/src/repositories/user_repository.dart';

class SaveUserUseCase {
  final UserRepository _repository;

  SaveUserUseCase(this._repository);

  Future<User> call(String name) async {
    final user = User.create(name: name);
    await _repository.saveUser(user);
    return user;
  }
}
