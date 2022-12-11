import 'package:friend_zone/src/app/constants/texts.dart';

class ValidatorHelper {
  static String? kPhoneValidator(String value) {
    if (value.length != 10) {
      return DefaultTexts.invalidPhoneNumber;
    } else {
      return null;
    }
  }

  static String? kVerificationCodeValidator(String value) {
    if (value.length != 6) {
      return '';
    } else {
      return null;
    }
  }

  static String? kNameValidator(String value) {
    return value.length < 2 ? DefaultTexts.typeAtLeastTwoLetters : null;
  }
}
