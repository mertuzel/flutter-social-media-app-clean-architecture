import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/authentication/verify/verify_phone_number_presenter.dart';
import 'package:friend_zone/src/data/exceptions/invalid_verification_code_expcetion.dart';
import 'package:friend_zone/src/data/exceptions/too_many_requests_exception.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/types/enum_start_phone_verification.dart';
import 'package:friend_zone/src/domain/types/response_authentication.dart';

class PhoneAuthenticationVerifyController extends Controller {
  final PhoneAuthenticationVerifyPresenter _presenter;

  PhoneAuthenticationVerifyController(
    AuthenticationRepository authenticationRepository,
    UserRepository userRepository,
    this.phoneNumber,
  ) : _presenter = PhoneAuthenticationVerifyPresenter(
          authenticationRepository,
          userRepository,
        );

  final String phoneNumber;

  bool isButtonDisabled = false;

  String verificationCode = '';

  AutovalidateMode? autovalidateMode;
  final formkey = GlobalKey<FormState>();

  late Timer timer;
  int countdown = 120;
  StartPhoneVerificationEnum? startPhoneVerificationEnum;
  bool secondTime = false;
  bool isLoading = false;
  bool manualCancel = false;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void onInitState() {
    startTimer();
    _presenter.resendVerificationCode(
      phoneNumber: phoneNumber,
      forInit: true,
    );
    super.onInitState();
  }

  @override
  void onDisposed() {
    timer.cancel();
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    _presenter.verifyPhoneCodeOnNext =
        (AuthenticationResponse? response) async {
      if (response == null) {
        Future.delayed(Duration.zero).then((_) {
          isLoading = false;
          refreshUI();
        });

        return;
      }

      if (response.isSignUp) {
        _presenter.updatePhoneNumber(phoneNumber);
      } else {
        KNavigator.navigateToSplash(getContext());
        isLoading = false;
        refreshUI();
      }
    };

    _presenter.verifyPhoneCodeOnError = (error) {
      Future.delayed(Duration.zero).then((_) {
        isLoading = false;
        refreshUI();
      });

      if (error is InvalidVerificationCodeException) {
        if (!manualCancel)
          kShowGenericErrorDialog(getContext(),
              content: DefaultTexts.wrongVerificationCode);
        return;
      }
      kShowGenericErrorDialog(getContext());
    };

    _presenter.updatePhoneNumberOnComplete = () async {
      KNavigator.navigateToSplash(getContext());
      isLoading = false;
      refreshUI();
    };

    _presenter.updatePhoneNumberOnError = (error) {};

    _presenter.startPhoneVerificationOnNext =
        (StartPhoneVerificationEnum? response) async {
      if (response == null) return;

      if (startPhoneVerificationEnum != response) {
        Future.delayed(Duration.zero).then((_) {
          isLoading = false;
          refreshUI();
        });

        startPhoneVerificationEnum = response;
        if (response == StartPhoneVerificationEnum.CODE_SENT) {
          startTimer();
        }

        autovalidateMode = AutovalidateMode.onUserInteraction;
      }
    };

    _presenter.startPhoneVerificationOnError = (error) {
      Future.delayed(Duration.zero).then((_) {
        isLoading = false;
        refreshUI();
      });
      if (error is TooManyRequestsException) {
        kShowGenericErrorDialog(
          getContext(),
          content: DefaultTexts.tooManyRequests,
        );
      } else {
        kShowGenericErrorDialog(getContext());
      }
    };
  }

  void setVerificationCode(String text) {
    verificationCode = text;
    if (autovalidateMode != null) {
      if (!formkey.currentState!.validate()) {
        isButtonDisabled = true;
      } else {
        isButtonDisabled = false;
      }
    }

    refreshUI();
  }

  void resendToken() {
    Future.delayed(Duration.zero).then((value) {
      textEditingController.clear();
      isLoading = true;
      refreshUI();
    });

    secondTime = true;
    _presenter.resendVerificationCode(
      phoneNumber: phoneNumber,
      forInit: false,
    );
  }

  void verifyCode() {
    if (formkey.currentState!.validate()) {
      Future.delayed(Duration.zero).then((_) {
        isLoading = true;
        refreshUI();
      });
      FocusScope.of(getContext()).unfocus();
      _presenter.verifyPhoneCode(
        smsCode: verificationCode,
        phoneNumber: phoneNumber,
      );
    } else {
      isButtonDisabled = true;
      autovalidateMode = AutovalidateMode.onUserInteraction;
      refreshUI();
    }
  }

  void startTimer() {
    countdown = 120;
    refreshUI();
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countdown == 0) {
          timer.cancel();
          refreshUI();
          if (secondTime) {
            Navigator.pop(getContext());
          }
        } else {
          countdown--;
          refreshUI();
        }
      },
    );
  }

  void cancelVerification() {
    _presenter.verifyPhoneCode(
      smsCode: '------',
      phoneNumber: phoneNumber,
    );
  }
}
