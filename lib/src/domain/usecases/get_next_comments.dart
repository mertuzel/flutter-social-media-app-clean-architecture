import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';

class GetNextComments extends UseCase<void, GetNextCommentsParams> {
  final PostRepository _postRepository;

  GetNextComments(
    this._postRepository,
  );

  @override
  Future<Stream<void>> buildUseCaseStream(GetNextCommentsParams? params) async {
    StreamController<void> controller = StreamController();
    try {
      await _postRepository.getNextComments(params!.targetId);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class GetNextCommentsParams {
  final String targetId;

  GetNextCommentsParams(this.targetId);
}
