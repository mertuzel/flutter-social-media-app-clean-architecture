import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';

class RemoveComment extends UseCase<void, RemoveCommentParams> {
  final PostRepository _postRepository;

  RemoveComment(this._postRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(RemoveCommentParams? params) async {
    StreamController<void> controller = StreamController();
    try {
      await _postRepository.removeComment(params!.postId, params.commentId);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class RemoveCommentParams {
  final String postId;
  final String commentId;

  RemoveCommentParams(
    this.postId,
    this.commentId,
  );
}
