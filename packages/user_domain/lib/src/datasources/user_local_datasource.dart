abstract class UserLocalDatasource {
  Future<void> saveUser(Map<String, dynamic> json);
  Future<Map<String, dynamic>?> getUser();
}
