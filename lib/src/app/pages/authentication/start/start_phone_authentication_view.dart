import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/pages/authentication/start/start_phone_authentication_controller.dart';
import 'package:friend_zone/src/app/widgets/k_app_bar.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';
import 'package:friend_zone/src/app/widgets/k_textformfield.dart';
import 'package:friend_zone/src/data/helpers/validator_helper.dart';
import 'package:friend_zone/src/data/repositories/data_authentication_repository.dart';
import 'package:lottie/lottie.dart';

class PhoneAuthenticationStartView extends View {
  PhoneAuthenticationStartView({Key? key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _PhoneAuthenticationStartViewState(
        PhoneAuthenticationStartController(
          DataAuthenticationRepository(),
        ),
      );
}

class _PhoneAuthenticationStartViewState extends ViewState<
    PhoneAuthenticationStartView, PhoneAuthenticationStartController> {
  _PhoneAuthenticationStartViewState(
      PhoneAuthenticationStartController controller)
      : super(controller);

  @override
  Widget get view {
    bool isKeyboardClosed = MediaQuery.of(context).viewInsets.bottom == 0.0;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomInset: false,
      body: ControlledWidgetBuilder<PhoneAuthenticationStartController>(
          builder: (context, controller) {
        return Stack(
          children: [
            Column(
              children: [
                KAppBar(
                  header: 'Type Phone',
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
                            SizedBox(height: size.height * 0.05),
                            SizedBox(
                              width: size.width * 0.76,
                              child: Form(
                                key: controller.formkey,
                                child: KTextFormField(
                                  onChanged: controller.setPhoneNumber,
                                  mainText: controller.mainText,
                                  mainTextColor: controller.mainTextColor,
                                  contentTextColor: kBlack,
                                  hintText: '(500) 000 00 00',
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  validator: ValidatorHelper.kPhoneValidator,
                                  nullAutoValidateMode:
                                      controller.autovalidateMode == null
                                          ? true
                                          : false,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ControlledWidgetBuilder<
                                    PhoneAuthenticationStartController>(
                                builder: (context, controller) {
                              return KButton(
                                bgColor: controller.isButtonDisabled
                                    ? kDisabled
                                    : kPrimary,
                                mainText: DefaultTexts.continuee,
                                textStyle: k14w600ProxWhiteButtonText(),
                                onPressed: controller.startPhoneVerification,
                              );
                            }),
                            if (!isKeyboardClosed)
                              Container(
                                width: size.width,
                                height: 200,
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
