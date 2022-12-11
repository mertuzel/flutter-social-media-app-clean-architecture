import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/pages/chats/chats_presenter.dart';
import 'package:friend_zone/src/domain/entities/message.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class ChatsController extends Controller {
  final ChatsPresenter _presenter;

  ChatsController(UserRepository userReposistory, ChatRepository chatRepository)
      : _presenter = ChatsPresenter(userReposistory, chatRepository);

  List<Message>? lastMessages;

  @override
  void onInitState() {
    _presenter.getLastMessagesOfUser();
    super.onInitState();
  }

  @override
  void initListeners() {
    _presenter.getLastMessagesOfUserOnError = (error) {};

    _presenter.getLastMessagesOfUserOnNext = (List<Message>? response) {
      if (response == null) return;
      lastMessages = response;
      refreshUI();
    };
  }
}
