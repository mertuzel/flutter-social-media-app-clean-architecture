import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/types/enum_start_phone_verification.dart';
import 'package:friend_zone/src/domain/usecases/start_phone_verification.dart';

class PhoneAuthenticationStartPresenter extends Presenter {
  late Function startPhoneVerificationOnNext;
  late Function startPhoneVerificationOnError;

  final StartPhoneVerification _startPhoneVerification;

  PhoneAuthenticationStartPresenter(
    AuthenticationRepository authenticationRepository,
  ) : _startPhoneVerification =
            StartPhoneVerification(authenticationRepository);

  void startPhoneVerification({
    required String phoneNumber,
  }) {
    _startPhoneVerification.execute(
      _StartPhoneVerificationObserver(this),
      StartPhoneVerificationParams(
        phoneNumber: phoneNumber,
        resendToken: false,
        forInit: false,
      ),
    );
  }

  @override
  void dispose() {
    _startPhoneVerification.dispose();
  }
}

class _StartPhoneVerificationObserver
    extends Observer<StartPhoneVerificationEnum?> {
  final PhoneAuthenticationStartPresenter _presenter;

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
