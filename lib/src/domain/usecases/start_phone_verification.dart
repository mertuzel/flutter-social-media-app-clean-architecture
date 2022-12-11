import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/types/enum_start_phone_verification.dart';

class StartPhoneVerification
    extends UseCase<StartPhoneVerificationEnum?, StartPhoneVerificationParams> {
  final AuthenticationRepository _authenticationRepository;
  StreamController<StartPhoneVerificationEnum?> _controller;

  StartPhoneVerification(this._authenticationRepository)
      : _controller = StreamController.broadcast();

  StreamSubscription? _streamSubscription;

  @override
  Future<Stream<StartPhoneVerificationEnum?>> buildUseCaseStream(
      StartPhoneVerificationParams? params) async {
    try {
      _controller = StreamController.broadcast();

      if (_streamSubscription != null) {
        await _streamSubscription!.cancel();
      }

      _streamSubscription = _authenticationRepository
          .startPhoneVerification(
        phoneNumber: params!.phoneNumber,
        resendToken: params.resendToken,
        forInit: params.forInit,
      )
          .listen((StartPhoneVerificationEnum? response) {
        if (!_controller.isClosed) {
          _controller.add(response);
        }
      });
      _streamSubscription?.onError((error, st) {
        if (!_controller.isClosed) {
          _controller.addError(error, st);
        }
      });
    } catch (error, stackTrace) {
      _controller.addError(error, stackTrace);
    }
    return _controller.stream;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

class StartPhoneVerificationParams {
  final String phoneNumber;
  final bool resendToken;
  final bool forInit;

  StartPhoneVerificationParams({
    required this.phoneNumber,
    required this.resendToken,
    required this.forInit,
  });
}
