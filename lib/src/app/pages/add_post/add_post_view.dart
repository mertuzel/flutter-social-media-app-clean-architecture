import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/pages/add_post/add_post_controller.dart';
import 'package:friend_zone/src/app/widgets/k_app_bar.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';
import 'package:friend_zone/src/app/widgets/k_textformfield.dart';
import 'package:friend_zone/src/data/helpers/validator_helper.dart';
import 'package:friend_zone/src/data/repositories/data_post_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';

class AddPostView extends View {
  @override
  State<StatefulWidget> createState() => _AddPostViewState(
        AddPostController(
          DataPostRepository(),
          DataUserRepository(),
        ),
      );
}

class _AddPostViewState extends ViewState<AddPostView, AddPostController> {
  _AddPostViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      backgroundColor: kBackground,
      body: ControlledWidgetBuilder<AddPostController>(
          builder: (context, controller) {
        return Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              KAppBar(
                header: 'Add Post',
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: kPhysics,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 60),
                        Text('Pick image from:'),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            KButton(
                              mainText: 'Gallery',
                              onPressed: () {
                                controller.pickImage(true, size.width - 34);
                              },
                              width: 70,
                              height: 44,
                              bgColor: kSecondary,
                            ),
                            SizedBox(width: 5),
                            KButton(
                              textStyle: k14w600ProxWhiteButtonText(
                                color: kSecondary,
                              ),
                              mainText: 'Camera',
                              onPressed: () {
                                controller.pickImage(false, size.width - 34);
                              },
                              width: 70,
                              height: 44,
                              bgColor: kWhite,
                              borderColor: kSecondary,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        controller.image != null
                            ? Image.file(
                                File(controller.image!.path),
                                width: 60,
                                height: 60,
                              )
                            : Container(),
                        SizedBox(height: 15),
                        KTextFormField(
                          onChanged: controller.onDescriptionTyped,
                          mainText: 'Description',
                          mainTextColor: kBlack,
                          contentTextColor: kBlack,
                          hintText: '',
                          maxLength: 250,
                          keyboardType: TextInputType.text,
                          validator: ValidatorHelper.kNameValidator,
                          nullAutoValidateMode: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          minLines: 6,
                          maxLines: 11,
                          padding: EdgeInsets.all(27),
                        ),
                        SizedBox(height: size.height * 0.05),
                        KButton(
                          mainText: 'Add',
                          onPressed: controller.onAddButtonPressed,
                        ),
                      ],
                    ),
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
