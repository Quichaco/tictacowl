import 'package:mocktail/mocktail.dart';
import 'package:user_domain/user_domain.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class FakeUser extends Fake implements User {}
