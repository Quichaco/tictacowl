import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';

part 'user_remote_datasource.g.dart';

abstract interface class UserRemoteDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser(String uid);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  // Firestore schema
  static const _collection = 'users';
  static const _fieldUid = 'uid';
  static const _fieldCreatedAt = 'createdAt';

  late final CollectionReference<User> _usersRef =
      _firestore.collection(_collection).withConverter<User>(
            fromFirestore: _userFromFirestore,
            toFirestore: _userToFirestore,
          );

  static User _userFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? _,
  ) {
    final data = doc.data();
    if (data == null) {
      throw FormatException('Document ${doc.id} has no data');
    }
    final createdAt = (data[_fieldCreatedAt] as Timestamp).toDate();
    return User.fromJson({
      ...data,
      _fieldUid: doc.id,
      _fieldCreatedAt: createdAt.toIso8601String(),
    });
  }

  static Map<String, Object?> _userToFirestore(User user, SetOptions? _) {
    return {
      ...user.toJson()..remove(_fieldUid),
      _fieldCreatedAt: Timestamp.fromDate(user.createdAt),
    };
  }

  @override
  Future<void> saveUser(User user) => _usersRef.doc(user.uid).set(user);

  @override
  Future<User?> getUser(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    return doc.data();
  }
}

@Riverpod(keepAlive: true)
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  return UserRemoteDataSourceImpl(FirebaseFirestore.instance);
}
