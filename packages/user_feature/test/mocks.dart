import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mocktail/mocktail.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/data/datasources/user_remote_datasource.dart';

// Firebase Auth mocks
class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class MockFirebaseUser extends Mock implements fb.User {}

class MockUserCredential extends Mock implements fb.UserCredential {}

// Datasource mocks
class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

// Fake classes for fallback values
class FakeUser extends Fake implements User {}
