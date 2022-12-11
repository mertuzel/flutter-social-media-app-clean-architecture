import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/message.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/get_all_messages_of_user.dart';

class ChatsPresenter extends Presenter {
  late Function getLastMessagesOfUserOnNext;
  late Function getLastMessagesOfUserOnError;

  final GetLastMessagesOfUser _getLastMessagesOfUser;

  ChatsPresenter(UserRepository userRepository, ChatRepository chatRepository)
      : _getLastMessagesOfUser =
            GetLastMessagesOfUser(chatRepository, userRepository);

  void getLastMessagesOfUser() {
    _getLastMessagesOfUser.execute(_GetLastMessagesOfUserObserver(this));
  }

  @override
  void dispose() {
    _getLastMessagesOfUser.dispose();
  }
}

class _GetLastMessagesOfUserObserver extends Observer<List<Message>?> {
  final ChatsPresenter _presenter;

  _GetLastMessagesOfUserObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(error) {
    _presenter.getLastMessagesOfUserOnError(error);
  }

  @override
  void onNext(List<Message>? messages) {
    _presenter.getLastMessagesOfUserOnNext(messages);
  }
}
