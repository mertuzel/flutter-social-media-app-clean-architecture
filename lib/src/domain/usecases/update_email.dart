import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class UpdateEmail extends UseCase<void, UpdateEmailParams> {
  final UserRepository _userRepository;

  UpdateEmail(this._userRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(UpdateEmailParams? params) async {
    StreamController<void> controller = StreamController();
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await _userRepository.updateEmail(
        uid: uid,
        email: params!.email,
      );
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class UpdateEmailParams {
  final String email;

  UpdateEmailParams(this.email);
}
