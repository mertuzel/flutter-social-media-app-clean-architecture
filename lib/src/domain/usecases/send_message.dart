import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/message.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';

class SendMessage extends UseCase<void, SendMessageParams> {
  final ChatRepository _chatRepository;

  SendMessage(this._chatRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(SendMessageParams? params) async {
    StreamController<void> controller = StreamController();
    try {
      await _chatRepository.sendMessage(params!.message, params.userIds);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class SendMessageParams {
  final Message message;
  final List<String> userIds;

  SendMessageParams(this.message, this.userIds);
}
