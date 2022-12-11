import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class UpdateUsername extends UseCase<void, UpdateUsernameParams> {
  final UserRepository _userRepository;

  UpdateUsername(this._userRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(UpdateUsernameParams? params) async {
    StreamController<void> controller = StreamController();
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await _userRepository.updateUsername(
        uid: uid,
        firstName: params!.firstName,
        lastName: params.lastName,
      );
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class UpdateUsernameParams {
  final String firstName;
  final String lastName;

  UpdateUsernameParams({
    required this.firstName,
    required this.lastName,
  });
}
