import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/update_username.dart';

class UsernamePresenter extends Presenter {
  late Function updateUsernameOnComplete;
  late Function updateUsernameOnError;

  final UpdateUsername _updateUsername;

  UsernamePresenter(UserRepository userRepository)
      : _updateUsername = UpdateUsername(userRepository);

  void updateUsername({
    required String firstName,
    required String lastName,
  }) {
    _updateUsername.execute(
      _UpdateUserNameObserver(this),
      UpdateUsernameParams(firstName: firstName, lastName: lastName),
    );
  }

  @override
  void dispose() {
    _updateUsername.dispose();
  }
}

class _UpdateUserNameObserver extends Observer<void> {
  final UsernamePresenter _presenter;

  _UpdateUserNameObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateUsernameOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateUsernameOnError(e);
  }

  @override
  void onNext(_) {}
}
