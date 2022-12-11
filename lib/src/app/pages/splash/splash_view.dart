// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';

import 'package:friend_zone/src/app/pages/splash/splash_controller.dart';
import 'package:friend_zone/src/data/repositories/data_authentication_repository.dart';
import 'package:friend_zone/src/data/repositories/data_chat_repository.dart';
import 'package:friend_zone/src/data/repositories/data_post_repository.dart';
import 'package:friend_zone/src/data/repositories/data_story_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:friend_zone/src/data/repositories/data_version_repistory.dart';
import 'package:lottie/lottie.dart';

class SplashView extends View {
  SplashView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashViewState(
        SplashController(
          DataVersionRepository(),
          DataAuthenticationRepository(),
          DataUserRepository(),
          DataPostRepository(),
          DataStoryRepository(),
          DataChatRepository(),
        ),
      );
}

class _SplashViewState extends ViewState<SplashView, SplashController> {
  _SplashViewState(SplashController controller) : super(controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      backgroundColor: kBackground,
      body: Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: Lottie.asset('assets/animations/loading.json'),
        ),
      ),
    );
  }
}
