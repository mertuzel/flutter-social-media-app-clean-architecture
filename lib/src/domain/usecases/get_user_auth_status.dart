import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/types/enum_user_auth_status.dart';

class GetUserAuthStatus extends UseCase<UserAuthenticationStatus, void> {
  final AuthenticationRepository _authenticationRepository;

  GetUserAuthStatus(this._authenticationRepository);

  @override
  Future<Stream<UserAuthenticationStatus>> buildUseCaseStream(
      void params) async {
    StreamController<UserAuthenticationStatus> controller = StreamController();
    try {
      UserAuthenticationStatus status =
          await _authenticationRepository.userAuthenticationStatus;
      controller.add(status);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}
