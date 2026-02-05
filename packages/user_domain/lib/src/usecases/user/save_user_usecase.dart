import 'package:common/common.dart';
import 'package:user_domain/src/models/user.dart';
import 'package:user_domain/src/repositories/user_repository.dart';

class SaveUserUseCase {
  final UserRepository _repository;

  SaveUserUseCase(this._repository);

  Future<Result<User>> call({
    required String uid,
    required String name,
    required String email,
  }) async {
    final user = User.create(uid: uid, name: name, email: email);
    final result = await _repository.saveUser(user);
    return result.map((_) => user);
  }
}
