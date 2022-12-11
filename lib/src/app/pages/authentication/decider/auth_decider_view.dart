import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/authentication/decider/auth_decider_controller.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';
import 'package:friend_zone/src/data/repositories/data_authentication_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:lottie/lottie.dart';

class AuthDeciderView extends View {
  @override
  State<StatefulWidget> createState() => _AuthDeciderViewState(
        AuthDeciderController(
          DataAuthenticationRepository(),
          DataUserRepository(),
        ),
      );
}

class _AuthDeciderViewState
    extends ViewState<AuthDeciderView, AuthDeciderController> {
  _AuthDeciderViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<AuthDeciderController>(
          builder: (context, controller) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select an authentication option'),
                  SizedBox(height: 15),
                  KButton(
                    mainText: 'Continue With Google',
                    iconPath: 'assets/icons/png/google.png',
                    bgColor: kWhite,
                    borderColor: kPrimary,
                    onPressed: controller.authenticateWithGoogle,
                    textStyle: k14w600ProxWhiteButtonText(
                      color: kPrimary,
                    ),
                  ),
                  SizedBox(height: 15),
                  KButton(
                    iconColor: kWhite,
                    iconPath: 'assets/icons/png/phone.png',
                    mainText: 'Continue With Phone',
                    onPressed: () {
                      KNavigator.navigateToPhoneAuthenticationStart(
                          context: context);
                    },
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
          ),
        );
      }),
    );
  }
}
