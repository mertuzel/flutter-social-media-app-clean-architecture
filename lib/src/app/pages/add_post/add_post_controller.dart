import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/add_post/add_post_presenter.dart';
import 'package:friend_zone/src/data/helpers/upload_helper.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddPostController extends Controller {
  final AddPostPresenter _presenter;

  AddPostController(
    PostRepository postRepository,
    UserRepository userRepository,
  ) : _presenter = AddPostPresenter(
          postRepository,
          userRepository,
        );

  CroppedFile? image;
  ImagePicker imagePicker = ImagePicker();
  String description = '';

  @override
  void initListeners() {
    _presenter.addPostOnComplete = () {
      Future.delayed(Duration.zero).then((value) {
        KNavigator.changeLoadingStatus(false);
      });
      Navigator.pop(getContext());
    };

    _presenter.addPostOnError = (e) {};
  }

  void pickImage(bool isGallery, double size) async {
    Future.delayed(Duration.zero)
        .then((value) => KNavigator.changeLoadingStatus(true));
    XFile? imageToCrop = await imagePicker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera);

    if (imageToCrop != null) {
      image = await ImageCropper().cropImage(
        sourcePath: imageToCrop.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: kSecondary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            activeControlsWidgetColor: kSecondary,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      refreshUI();
    }

    Future.delayed(Duration.zero)
        .then((value) => KNavigator.changeLoadingStatus(false));
  }

  void onDescriptionTyped(String text) {
    description = text;
    refreshUI();
  }

  void onAddButtonPressed() async {
    if (image != null) {
      Future.delayed(Duration.zero).then((value) {
        KNavigator.changeLoadingStatus(true);
      });
      _presenter.addPost(Post(
          id: '',
          imageUrl: await UploadHelper().uploadImageToStorage(
            image!.path,
            FirebaseAuth.instance.currentUser!.uid,
            isPost: true,
          ),
          description: description,
          publisher: '',
          publisherId: '',
          publisherLogoUrl: '',
          publishedOn: DateTime.now()));
    }
  }
}
