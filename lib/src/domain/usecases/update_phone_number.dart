import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class UpdatePhoneNumber extends UseCase<void, UpdatePhoneNumberParams> {
  final UserRepository _userRepository;

  UpdatePhoneNumber(this._userRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdatePhoneNumberParams? params) async {
    StreamController<void> controller = StreamController();
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await _userRepository.updatePhoneNumber(
        uid: uid,
        phoneNumber: params!.phoneNumber,
      );
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class UpdatePhoneNumberParams {
  final String phoneNumber;

  UpdatePhoneNumberParams(this.phoneNumber);
}
