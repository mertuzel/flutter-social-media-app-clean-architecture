import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/add_story/add_story_presenter.dart';
import 'package:friend_zone/src/data/helpers/upload_helper.dart';
import 'package:friend_zone/src/domain/entities/story_item.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryController extends Controller {
  final AddStoryPresenter _presenter;

  AddStoryController(
    StoryRepository storyRepository,
    UserRepository userRepository,
  ) : _presenter = AddStoryPresenter(
          storyRepository,
          userRepository,
        );

  XFile? image;
  ImagePicker imagePicker = ImagePicker();

  @override
  void onInitState() {
    openCamera();
    super.onInitState();
  }

  @override
  void initListeners() {
    _presenter.addStoryOnComplete = () {
      Future.delayed(Duration.zero).then((value) {
        KNavigator.changeLoadingStatus(false);
      });

      Navigator.pop(getContext());
    };

    _presenter.addStoryOnError = () {};
  }

  void openCamera() async {
    image = null;
    refreshUI();
    image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      Navigator.of(getContext()).pop();
    }
    refreshUI();
  }

  void addStory() async {
    KNavigator.changeLoadingStatus(true);
    _presenter.addStory(
      StoryItem(
        id: '',
        imageUrl: await UploadHelper().uploadImageToStorage(
            image!.path, FirebaseAuth.instance.currentUser!.uid),
        sharedOn: DateTime.now(),
        isSeen: false,
      ),
    );
  }
}
