import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/repositories/version_repository.dart';
import 'package:friend_zone/src/domain/types/enum_user_auth_status.dart';
import 'package:friend_zone/src/domain/types/enum_version_status.dart';
import 'package:friend_zone/src/domain/usecases/get_user_auth_status.dart';
import 'package:friend_zone/src/domain/usecases/get_version_status.dart';
import 'package:friend_zone/src/domain/usecases/initialize_app.dart';

class SplashPresenter extends Presenter {
  late Function getVersionStatusOnNext;
  late Function getVersionStatusOnError;

  late Function getUserAuthStatusOnNext;
  late Function getUserAuthStatusOnError;

  late Function initializeAppOnComplete;
  late Function initializeAppOnError;

  final GetVersionStatus _getVersionStatus;
  final GetUserAuthStatus _getUserAuthStatus;
  final InitializeApp _initializeApp;

  SplashPresenter(
    VersionRepository versionRepository,
    AuthenticationRepository authenticationRepository,
    UserRepository userRepository,
    PostRepository postRepository,
    StoryRepository storyRepository,
    ChatRepository chatRepository,
  )   : _getVersionStatus = GetVersionStatus(versionRepository),
        _getUserAuthStatus = GetUserAuthStatus(authenticationRepository),
        _initializeApp = InitializeApp(
          authenticationRepository,
          postRepository,
          storyRepository,
          userRepository,
          versionRepository,
          chatRepository,
        );

  void getVersionStatus() {
    _getVersionStatus.execute(_GetVersionStatusObserver(this));
  }

  void getUserAuthStatus() {
    _getUserAuthStatus.execute(_GetUserAuthStatusObserver(this));
  }

  void initializeApp() {
    _initializeApp.execute(_InitializeAppObserver(this));
  }

  @override
  void dispose() {
    _getVersionStatus.dispose();
    _getUserAuthStatus.dispose();
    _initializeApp.dispose();
  }
}

class _GetVersionStatusObserver extends Observer<VersionStatus> {
  final SplashPresenter _presenter;

  _GetVersionStatusObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getVersionStatusOnError(e);
  }

  @override
  void onNext(VersionStatus? status) {
    _presenter.getVersionStatusOnNext(status);
  }
}

class _GetUserAuthStatusObserver extends Observer<UserAuthenticationStatus> {
  final SplashPresenter _presenter;

  _GetUserAuthStatusObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getUserAuthStatusOnError(e);
  }

  @override
  void onNext(UserAuthenticationStatus? status) {
    _presenter.getUserAuthStatusOnNext(status);
  }
}

class _InitializeAppObserver extends Observer<void> {
  final SplashPresenter _presenter;

  _InitializeAppObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.initializeAppOnComplete();
  }

  @override
  void onError(e) {
    _presenter.initializeAppOnError(e);
  }

  @override
  void onNext(_) {}
}
