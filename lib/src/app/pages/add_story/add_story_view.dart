import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/pages/add_story/add_story_controller.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';
import 'package:friend_zone/src/data/repositories/data_story_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';

class AddStoryView extends View {
  @override
  State<StatefulWidget> createState() => _AddStoryViewState(
        AddStoryController(
          DataStoryRepository(),
          DataUserRepository(),
        ),
      );
}

class _AddStoryViewState extends ViewState<AddStoryView, AddStoryController> {
  _AddStoryViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<AddStoryController>(
          builder: (context, controller) {
        return Container(
          width: size.width,
          height: size.height,
          child: Stack(children: [
            if (controller.image != null)
              Container(
                child: Image.file(
                  File(
                    controller.image!.path,
                  ),
                ),
              ),
            if (controller.image != null)
              Positioned(
                bottom: 50,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    KButton(
                      mainText: 'Try again',
                      onPressed: controller.openCamera,
                      width: 100,
                      bgColor: kWhite,
                      borderColor: kSecondary,
                      textStyle: k14w600ProxWhiteButtonText(
                        color: kSecondary,
                      ),
                    ),
                    const SizedBox(width: 15),
                    KButton(
                      bgColor: kSecondary,
                      mainText: 'Add',
                      onPressed: controller.addStory,
                      width: 100,
                    ),
                  ],
                ),
              ),
          ]),
        );
      }),
    );
  }
}
