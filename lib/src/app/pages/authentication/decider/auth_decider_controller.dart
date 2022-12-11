import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/authentication/decider/auth_decider_presenter.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/types/response_authentication.dart';

class AuthDeciderController extends Controller {
  final AuthDeciderPresenter _presenter;

  AuthDeciderController(AuthenticationRepository authenticationRepository,
      UserRepository userRepository)
      : _presenter =
            AuthDeciderPresenter(userRepository, authenticationRepository);

  bool isLoading = false;

  @override
  void initListeners() {
    _presenter.authenticateWithGoogleOnNext =
        (AuthenticationResponse? response) {
      if (response == null) {
        Future.delayed(Duration.zero).then((value) {
          isLoading = false;
          refreshUI();
        });
        return;
      }

      if (response.isSignUp) {
        _presenter.updateEmail(response.email ?? '');
      } else {
        Future.delayed(Duration.zero).then((value) {
          isLoading = false;
          refreshUI();
        });
        KNavigator.navigateToSplash(getContext());
      }
    };

    _presenter.authenticateWithGoogleOnError = (e) {};

    _presenter.updateEmailOnComplete = () {
      Future.delayed(Duration.zero).then((value) {
        isLoading = false;
        refreshUI();
      });
      KNavigator.navigateToSplash(getContext());
    };

    _presenter.updateEmailOnError = (e) {};
  }

  void authenticateWithGoogle() {
    Future.delayed(Duration.zero).then((value) {
      isLoading = true;
      refreshUI();
    });
    _presenter.authenticateWithGoogle();
  }
}
