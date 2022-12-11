import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/splash/splash_presenter.dart';
import 'package:friend_zone/src/app/widgets/k_dialog.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/repositories/version_repository.dart';
import 'package:friend_zone/src/domain/types/enum_user_auth_status.dart';
import 'package:friend_zone/src/domain/types/enum_version_status.dart';

class SplashController extends Controller {
  final SplashPresenter _presenter;

  SplashController(
    VersionRepository versionRepository,
    AuthenticationRepository authenticationRepository,
    UserRepository userRepository,
    PostRepository postRepository,
    StoryRepository storyRepository,
    ChatRepository chatRepository,
  ) : _presenter = SplashPresenter(
          versionRepository,
          authenticationRepository,
          userRepository,
          postRepository,
          storyRepository,
          chatRepository,
        );

  @override
  void onInitState() {
    _presenter.getVersionStatus();
    super.onInitState();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    _presenter.getVersionStatusOnNext = (VersionStatus status) async {
      switch (status) {
        case VersionStatus.NO_INTERNET_CONNECTION:
          await showDialog(
              context: getContext(),
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: KDialog(
                    header: DefaultTexts.noInternetConnectionHeader,
                    imagePath:
                        'assets/images/svg/dialog-no-internet-connection.svg',
                    content: DefaultTexts.noInternetConnectionContent,
                    button1Text: null,
                  ),
                );
              });
          break;
        case VersionStatus.READY_TO_GO:
          Future.delayed(Duration(seconds: 2)).then((_) {
            _presenter.getUserAuthStatus();
          });
          break;
      }
    };

    _presenter.getVersionStatusOnError = (error) {};

    _presenter.getUserAuthStatusOnNext = (UserAuthenticationStatus status) {
      print('user auth status');
      print(status);
      switch (status) {
        case UserAuthenticationStatus.AUTHENTICATED:
          _presenter.initializeApp();
          break;
        case UserAuthenticationStatus.NOT_AUTHENTICATED:
          KNavigator.navigateToAuthDecider(getContext());
          break;
        case UserAuthenticationStatus.MISSING_USERNAME:
          KNavigator.navigateToUsername(getContext());
          break;
      }
    };

    _presenter.getUserAuthStatusOnError = (error) {};

    _presenter.initializeAppOnComplete = () {
      KNavigator.navigateToHome(getContext());
    };

    _presenter.initializeAppOnError = (e) {};
  }
}
