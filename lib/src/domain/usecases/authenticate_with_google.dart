import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/types/response_authentication.dart';

class AuthenticateWithGoogle extends UseCase<AuthenticationResponse?, void> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticateWithGoogle(this._authenticationRepository);

  @override
  Future<Stream<AuthenticationResponse?>> buildUseCaseStream(
      void params) async {
    StreamController<AuthenticationResponse?> controller = StreamController();
    try {
      AuthenticationResponse? response =
          await _authenticationRepository.authenticateWithGoogle();
      controller.add(response);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}
