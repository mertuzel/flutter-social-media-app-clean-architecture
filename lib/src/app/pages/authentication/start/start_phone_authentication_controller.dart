import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/authentication/start/start_phone_authentication_presenter.dart';
import 'package:friend_zone/src/data/exceptions/invalid_phone_number_exception.dart';
import 'package:friend_zone/src/data/exceptions/too_many_requests_exception.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/types/enum_start_phone_verification.dart';

class PhoneAuthenticationStartController extends Controller {
  final PhoneAuthenticationStartPresenter _presenter;

  PhoneAuthenticationStartController(
    AuthenticationRepository authenticationRepository,
  ) : _presenter = PhoneAuthenticationStartPresenter(authenticationRepository);

  String phoneNumber = '';
  bool isButtonDisabled = false;
  final formkey = GlobalKey<FormState>();
  AutovalidateMode? autovalidateMode;

  String mainText = DefaultTexts.typePhoneNumber;
  Color mainTextColor = kPrimary;
  bool isLoading = false;
  StartPhoneVerificationEnum? startPhoneVerificationEnum;

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    _presenter.startPhoneVerificationOnNext =
        (StartPhoneVerificationEnum? response) async {
      if (response == null) {
        isLoading = false;
        refreshUI();
        return;
      }

      if (response == StartPhoneVerificationEnum.CODE_SENT &&
          startPhoneVerificationEnum != StartPhoneVerificationEnum.CODE_SENT) {
        startPhoneVerificationEnum = response;
        Future.delayed(Duration.zero).then((_) {
          isLoading = false;
          refreshUI();
        });
        await KNavigator.navigateToPhoneAuthenticationVerify(
          context: getContext(),
          phoneNumber: '+90' + phoneNumber,
        );
        startPhoneVerificationEnum = null;
        autovalidateMode = AutovalidateMode.onUserInteraction;
      }
    };

    _presenter.startPhoneVerificationOnError = (error) {
      print('controller error');
      print(error.runtimeType);
      Future.delayed(Duration.zero).then((_) {
        isLoading = false;
        refreshUI();
      });

      if (error is TooManyRequestsException) {
        kShowGenericErrorDialog(
          getContext(),
          content: DefaultTexts.tooManyRequests,
        );
      } else if (error is InvalidPhoneNumberException) {
        kShowGenericErrorDialog(
          getContext(),
          content: DefaultTexts.invalidPhoneNumber,
        );
      } else {
        kShowGenericErrorDialog(getContext());
      }
    };
  }

  void setPhoneNumber(String text) {
    phoneNumber = text;
    if (autovalidateMode != null) {
      mainText = DefaultTexts.typePhoneNumber;
      mainTextColor = kBlack;
      if (!formkey.currentState!.validate()) {
        isButtonDisabled = true;
      } else {
        isButtonDisabled = false;
      }
    }

    refreshUI();
  }

  void startPhoneVerification() {
    if (formkey.currentState!.validate()) {
      isLoading = true;
      refreshUI();
      FocusScope.of(getContext()).unfocus();
      _presenter.startPhoneVerification(
        phoneNumber: '+90' + phoneNumber,
      );
    } else {
      isButtonDisabled = true;
      refreshUI();
    }
    autovalidateMode = AutovalidateMode.onUserInteraction;
  }
}
