import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/message.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class GetLastMessagesOfUser extends UseCase<List<Message>?, void> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  final StreamController<List<Message>?> _controller;

  GetLastMessagesOfUser(this._chatRepository, this._userRepository)
      : _controller = StreamController.broadcast();

  @override
  Future<Stream<List<Message>?>> buildUseCaseStream(void params) async {
    try {
      final uid = _userRepository.currentUser.id;
      _chatRepository
          .getLastMessagesOfUser(uid)
          .listen((List<Message>? messages) {
        if (!_controller.isClosed) _controller.add(messages);
      });
    } catch (error, stackTrace) {
      _controller.addError(error, stackTrace);
    }
    return _controller.stream;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
