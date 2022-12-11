import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/pages/username/username_controller.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';
import 'package:friend_zone/src/app/widgets/k_textformfield.dart';
import 'package:friend_zone/src/data/helpers/validator_helper.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:lottie/lottie.dart';

class UsernameView extends View {
  UsernameView({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _UsernameViewState(
        UsernameController(
          DataUserRepository(),
        ),
      );
}

class _UsernameViewState extends ViewState<UsernameView, UsernameController> {
  _UsernameViewState(UsernameController controller) : super(controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<UsernameController>(
          builder: (context, controller) {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: kPhysics,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.76,
                      child: Text(
                        DefaultTexts.typePersonalInfos,
                        textAlign: TextAlign.center,
                        style: k14w400AxiBlackGeneralText(color: kBlack),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Form(
                      key: controller.formkey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width * 0.76,
                            child: KTextFormField(
                              onChanged: controller.onfirstNameChanged,
                              mainText: DefaultTexts.yourFirstName,
                              mainTextColor: kBlack,
                              contentTextColor: kBlack,
                              hintText: DefaultTexts.typeYourFirstName,
                              maxLength: 30,
                              keyboardType: TextInputType.text,
                              validator: ValidatorHelper.kNameValidator,
                              nullAutoValidateMode:
                                  controller.autovalidateMode == null
                                      ? true
                                      : false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              isSecurityCode: false,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: size.width * 0.76,
                            child: KTextFormField(
                              isSecurityCode: false,
                              onChanged: controller.onLastNameChanged,
                              mainText: DefaultTexts.yourLastName,
                              mainTextColor: kBlack,
                              contentTextColor: kBlack,
                              hintText: DefaultTexts.typeYourLastName,
                              maxLength: 30,
                              keyboardType: TextInputType.name,
                              nullAutoValidateMode:
                                  controller.autovalidateMode == null
                                      ? true
                                      : false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ValidatorHelper.kNameValidator,
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          ControlledWidgetBuilder<UsernameController>(
                              builder: (context, controller) {
                            return KButton(
                              mainText: DefaultTexts.signUp,
                              onPressed: controller.isButtonDisabled
                                  ? () {}
                                  : controller.onButtonPressed,
                              bgColor: controller.isButtonDisabled
                                  ? kDisabled
                                  : kPrimary,
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),
            if (controller.isLoading)
              Container(
                height: size.height,
                width: size.width,
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
