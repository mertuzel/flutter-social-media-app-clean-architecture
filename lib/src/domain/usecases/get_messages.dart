import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/message.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';

class GetMessages extends UseCase<List<Message>?, GetMesagesParams> {
  final ChatRepository _chatRepository;
  final StreamController<List<Message>?> _controller;

  GetMessages(this._chatRepository)
      : _controller = StreamController.broadcast();

  @override
  Future<Stream<List<Message>?>> buildUseCaseStream(
      GetMesagesParams? params) async {
    try {
      _chatRepository
          .getMessages(params!.userIds)
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

class GetMesagesParams {
  final List<String> userIds;

  GetMesagesParams(this.userIds);
}
