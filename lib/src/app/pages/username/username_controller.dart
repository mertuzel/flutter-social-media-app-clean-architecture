import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/username/username_presenter.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class UsernameController extends Controller {
  final UsernamePresenter _presenter;

  UsernameController(UserRepository userRepository)
      : _presenter = UsernamePresenter(
          userRepository,
        );

  String firstName = '';
  String lastName = '';

  bool isButtonDisabled = false;

  AutovalidateMode? autovalidateMode;
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initListeners() {
    _presenter.updateUsernameOnComplete = () {
      KNavigator.navigateToSplash(getContext());
    };

    _presenter.updateUsernameOnError = (error) {};
  }

  void onfirstNameChanged(String text) {
    firstName = text;
    if (autovalidateMode != null) {
      isAllValid();
    }

    refreshUI();
  }

  void onLastNameChanged(String text) {
    lastName = text;
    if (autovalidateMode != null) {
      isAllValid();
    }
    refreshUI();
  }

  void onCheckboxPressed() {
    if (autovalidateMode != null &&
        autovalidateMode == AutovalidateMode.onUserInteraction) {
      isAllValid();
    }
    refreshUI();
  }

  void onButtonPressed() {
    if (isAllValid()) {
      isLoading = true;
      refreshUI();
      FocusScope.of(getContext()).unfocus();
      _presenter.updateUsername(
        firstName: firstName,
        lastName: lastName,
      );
    } else {
      autovalidateMode = AutovalidateMode.onUserInteraction;
    }
  }

  bool isAllValid() {
    if (formkey.currentState!.validate()) {
      isButtonDisabled = false;
      refreshUI();
      return true;
    } else {
      isButtonDisabled = true;
    }
    refreshUI();
    return false;
  }
}
