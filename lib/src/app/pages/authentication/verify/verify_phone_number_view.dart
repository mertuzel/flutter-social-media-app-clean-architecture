import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/pages/authentication/verify/verify_phone_number_controller.dart';
import 'package:friend_zone/src/app/widgets/k_app_bar.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';
import 'package:friend_zone/src/app/widgets/k_textformfield.dart';
import 'package:friend_zone/src/data/helpers/validator_helper.dart';
import 'package:friend_zone/src/data/repositories/data_authentication_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:friend_zone/src/data/utils/string_utils.dart';
import 'package:friend_zone/src/domain/types/enum_start_phone_verification.dart';
import 'package:lottie/lottie.dart';

class PhoneAuthenticationVerifyView extends View {
  final String phoneNumber;
  PhoneAuthenticationVerifyView({
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _PhoneAuthenticationVerifyViewState(
        PhoneAuthenticationVerifyController(
          DataAuthenticationRepository(),
          DataUserRepository(),
          phoneNumber,
        ),
      );
}

class _PhoneAuthenticationVerifyViewState extends ViewState<
    PhoneAuthenticationVerifyView, PhoneAuthenticationVerifyController> {
  _PhoneAuthenticationVerifyViewState(
      PhoneAuthenticationVerifyController controller)
      : super(controller);

  @override
  Widget get view {
    bool isKeyboardClosed = MediaQuery.of(context).viewInsets.bottom == 0.0;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackground,
      key: globalKey,
      resizeToAvoidBottomInset: false,
      body: ControlledWidgetBuilder<PhoneAuthenticationVerifyController>(
          builder: (context, controller) {
        return Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  KAppBar(
                    header: 'Type Code',
                    onPressed: () {
                      controller.manualCancel = true;
                      if (controller.startPhoneVerificationEnum == null ||
                          controller.startPhoneVerificationEnum ==
                              StartPhoneVerificationEnum.CODE_SENT) {
                        controller.cancelVerification();
                      }
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: CustomScrollView(
                      physics: kPhysics,
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * 0.76,
                                child: Text(
                                  DefaultTexts.enterVerificationCode,
                                  textAlign: TextAlign.center,
                                  style: k14w400AxiBlackGeneralText(
                                    color: kBlack,
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.05),
                              ControlledWidgetBuilder<
                                  PhoneAuthenticationVerifyController>(
                                builder: (context, controller) {
                                  return SizedBox(
                                    width: size.width * 0.76,
                                    child: Form(
                                      key: controller.formkey,
                                      child: KTextFormField(
                                        textEditingController:
                                            controller.textEditingController,
                                        onChanged:
                                            controller.setVerificationCode,
                                        mainText: DefaultTexts.securityCode,
                                        mainTextColor: kPrimary,
                                        contentTextColor: kPrimary,
                                        hintText: '******',
                                        maxLength: 6,
                                        keyboardType: TextInputType.number,
                                        validator: ValidatorHelper
                                            .kVerificationCodeValidator,
                                        nullAutoValidateMode:
                                            controller.autovalidateMode == null
                                                ? true
                                                : false,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        isSecurityCode: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              ControlledWidgetBuilder<
                                      PhoneAuthenticationVerifyController>(
                                  builder: (context, controller) {
                                return KButton(
                                  bgColor: controller.isButtonDisabled
                                      ? kDisabled
                                      : kPrimary,
                                  mainText: DefaultTexts.continuee,
                                  textStyle: k14w600ProxWhiteButtonText(),
                                  onPressed: controller.verifyCode,
                                );
                              }),
                              SizedBox(height: size.height * 0.04),
                              Text(
                                DefaultTexts.remainingTime,
                                style: k14w400AxiBlackGeneralText(
                                  color: kBlack,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ControlledWidgetBuilder<
                                      PhoneAuthenticationVerifyController>(
                                  builder: (context, controller) {
                                return Text(
                                  StringUtils.getCountdownTime(
                                      controller.countdown),
                                  style: k26w400AxiVermillionTimerText(
                                    color: controller.countdown <= 30
                                        ? kRed
                                        : kBlack,
                                  ),
                                );
                              }),
                              const SizedBox(height: 5),
                              ControlledWidgetBuilder<
                                      PhoneAuthenticationVerifyController>(
                                  builder: (context, controller) {
                                if (controller.countdown == 0)
                                  return GestureDetector(
                                    onTap: () {
                                      controller.resendToken();
                                    },
                                    child: Text(
                                      DefaultTexts.sendCodeAgain,
                                      style: k12w400AxiBlackLoading(
                                        color: kBlack,
                                        isUnderline: true,
                                      ),
                                    ),
                                  );
                                else {
                                  return Container();
                                }
                              }),
                              if (!isKeyboardClosed)
                                Container(
                                  width: size.width,
                                  height: 400,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isLoading)
              Container(
                height: size.height,
                width: size.width,
                padding: EdgeInsets.only(bottom: size.height * 0.05),
                color: kBlack.withOpacity(0.6),
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
