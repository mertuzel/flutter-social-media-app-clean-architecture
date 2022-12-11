import 'package:friend_zone/src/domain/entities/user.dart';

abstract class UserRepository {
  void killInstance();

  User get currentUser;
  Future<void> initializeRepository();

  Future<void> updatePhoneNumber({
    required String uid,
    required String phoneNumber,
  });

  Future<void> updateEmail({
    required String uid,
    required String email,
  });

  Future<void> updateUsername({
    required String uid,
    required String firstName,
    required String lastName,
  });

  Future<List<User>> getUsers();
}
