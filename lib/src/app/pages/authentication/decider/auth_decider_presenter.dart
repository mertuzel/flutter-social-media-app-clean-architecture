import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/types/response_authentication.dart';
import 'package:friend_zone/src/domain/usecases/authenticate_with_google.dart';
import 'package:friend_zone/src/domain/usecases/update_email.dart';

class AuthDeciderPresenter extends Presenter {
  late Function authenticateWithGoogleOnNext;
  late Function authenticateWithGoogleOnError;

  late Function updateEmailOnComplete;
  late Function updateEmailOnError;

  final AuthenticateWithGoogle _authenticateWithGoogle;
  final UpdateEmail _updateEmail;

  AuthDeciderPresenter(UserRepository userRepository,
      AuthenticationRepository authenticationRepository)
      : _authenticateWithGoogle =
            AuthenticateWithGoogle(authenticationRepository),
        _updateEmail = UpdateEmail(userRepository);

  void authenticateWithGoogle() {
    _authenticateWithGoogle.execute(_AuthenticateWithGoogleObserver(this));
  }

  void updateEmail(String email) {
    _updateEmail.execute(
      _UpdateEmailObserver(this),
      UpdateEmailParams(email),
    );
  }

  @override
  void dispose() {
    _updateEmail.dispose();
    _authenticateWithGoogle.dispose();
  }
}

class _AuthenticateWithGoogleObserver
    extends Observer<AuthenticationResponse?> {
  final AuthDeciderPresenter _presenter;

  _AuthenticateWithGoogleObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(error) {
    _presenter.authenticateWithGoogleOnError(error);
  }

  @override
  void onNext(AuthenticationResponse? messages) {
    _presenter.authenticateWithGoogleOnNext(messages);
  }
}

class _UpdateEmailObserver extends Observer<void> {
  final AuthDeciderPresenter _presenter;

  _UpdateEmailObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateEmailOnComplete();
  }

  @override
  void onError(error) {
    _presenter.updateEmailOnError(error);
  }

  @override
  void onNext(_) {}
}
