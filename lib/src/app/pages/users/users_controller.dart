import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/pages/users/users_presenter.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class UsersController extends Controller {
  final UsersPresenter _presenter;

  UsersController(UserRepository userReposistory)
      : _presenter = UsersPresenter(userReposistory);

  List<User>? users;
  bool isLoading = true;

  @override
  void onInitState() {
    _presenter.getUsers();
    super.onInitState();
  }

  @override
  void initListeners() {
    _presenter.getUsersOnNext = (List<User> response) {
      users = response;
      refreshUI();
    };

    _presenter.getUsersOnError = (e) {};
  }
}
