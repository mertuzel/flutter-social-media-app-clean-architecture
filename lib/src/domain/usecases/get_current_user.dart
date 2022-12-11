import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class GetCurrentUser extends UseCase<User, void> {
  final UserRepository _userRepository;

  GetCurrentUser(this._userRepository);

  @override
  Future<Stream<User>> buildUseCaseStream(void params) async {
    StreamController<User> controller = StreamController();
    try {
      User currentUser = _userRepository.currentUser;
      controller.add(currentUser);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}
