import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/types/enum_start_phone_verification.dart';
import 'package:friend_zone/src/domain/types/response_authentication.dart';
import 'package:friend_zone/src/domain/usecases/start_phone_verification.dart';
import 'package:friend_zone/src/domain/usecases/update_phone_number.dart';
import 'package:friend_zone/src/domain/usecases/verify_phone_code.dart';

class PhoneAuthenticationVerifyPresenter extends Presenter {
  late Function verifyPhoneCodeOnNext;
  late Function verifyPhoneCodeOnError;

  late Function updatePhoneNumberOnComplete;
  late Function updatePhoneNumberOnError;

  late Function startPhoneVerificationOnNext;
  late Function startPhoneVerificationOnError;

  final VerifiyPhoneCode _verifiyPhoneCode;
  final UpdatePhoneNumber _updatePhoneNumber;
  final StartPhoneVerification _startPhoneVerification;

  PhoneAuthenticationVerifyPresenter(
    AuthenticationRepository authenticationRepository,
    UserRepository userRepository,
  )   : _verifiyPhoneCode = VerifiyPhoneCode(authenticationRepository),
        _updatePhoneNumber = UpdatePhoneNumber(userRepository),
        _startPhoneVerification =
            StartPhoneVerification(authenticationRepository);

  void verifyPhoneCode({
    required String smsCode,
    required String phoneNumber,
  }) {
    _verifiyPhoneCode.execute(
      _VerifyPhoneCodeObserver(this),
      VerifiyPhoneCodeParams(
        smsCode: smsCode,
        phoneNumber: phoneNumber,
      ),
    );
  }

  void updatePhoneNumber(String phoneNumber) {
    _updatePhoneNumber.execute(
      _UpdatePhoneNumberObserver(this),
      UpdatePhoneNumberParams(
        phoneNumber,
      ),
    );
  }

  void resendVerificationCode({
    required String phoneNumber,
    required bool forInit,
  }) {
    _startPhoneVerification.execute(
      _StartPhoneVerificationObserver(this),
      StartPhoneVerificationParams(
        phoneNumber: phoneNumber,
        resendToken: true,
        forInit: forInit,
      ),
    );
  }

  @override
  void dispose() {
    _verifiyPhoneCode.dispose();
    _startPhoneVerification.dispose();
    _updatePhoneNumber.dispose();
  }
}

class _VerifyPhoneCodeObserver extends Observer<AuthenticationResponse?> {
  final PhoneAuthenticationVerifyPresenter _presenter;

  _VerifyPhoneCodeObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.verifyPhoneCodeOnError(e);
  }

  @override
  void onNext(AuthenticationResponse? response) {
    _presenter.verifyPhoneCodeOnNext(response);
  }
}

class _UpdatePhoneNumberObserver extends Observer<void> {
  final PhoneAuthenticationVerifyPresenter _presenter;

  _UpdatePhoneNumberObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updatePhoneNumberOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updatePhoneNumberOnError(e);
  }

  @override
  void onNext(_) {}
}

class _StartPhoneVerificationObserver
    extends Observer<StartPhoneVerificationEnum?> {
  final PhoneAuthenticationVerifyPresenter _presenter;

  _StartPhoneVerificationObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.startPhoneVerificationOnError(e);
  }

  @override
  void onNext(StartPhoneVerificationEnum? response) {
    _presenter.startPhoneVerificationOnNext(response);
  }
}
