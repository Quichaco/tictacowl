import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';
import 'package:xoapp/src/data/datasources/user_local_datasource.dart';

part 'user_repository_impl.g.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<void> saveUser(User user) => _datasource.saveUser(user.toJson());

  @override
  Future<User?> getUser() async {
    final json = await _datasource.getUser();
    return json != null ? User.fromJson(json) : null;
  }
}

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(ref.watch(userLocalDatasourceProvider));
}
