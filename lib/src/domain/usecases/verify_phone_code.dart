import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/types/response_authentication.dart';

class VerifiyPhoneCode
    extends UseCase<AuthenticationResponse?, VerifiyPhoneCodeParams> {
  final AuthenticationRepository _authenticationRepository;

  VerifiyPhoneCode(this._authenticationRepository);

  @override
  Future<Stream<AuthenticationResponse?>> buildUseCaseStream(
      VerifiyPhoneCodeParams? params) async {
    StreamController<AuthenticationResponse?> controller = StreamController();
    try {
      final AuthenticationResponse? response =
          await _authenticationRepository.verifyPhoneCode(
        smsCode: params!.smsCode,
        phoneNumber: params.phoneNumber,
      );

      controller.add(response);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class VerifiyPhoneCodeParams {
  final String smsCode;
  final String phoneNumber;

  VerifiyPhoneCodeParams({
    required this.smsCode,
    required this.phoneNumber,
  });
}
