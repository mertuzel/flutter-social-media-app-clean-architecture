import 'dart:async';
import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/comment.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';

class GetComments
    extends UseCase<UnmodifiableListView<Comment>, GetCommentsParams> {
  final PostRepository _postRepository;
  final StreamController<UnmodifiableListView<Comment>?> _controller;

  GetComments(this._postRepository)
      : _controller = StreamController.broadcast();
  @override
  Future<Stream<UnmodifiableListView<Comment>?>> buildUseCaseStream(
      params) async {
    try {
      _postRepository
          .getComments(params!.targetId)
          .listen((UnmodifiableListView<Comment>? comments) {
        if (!_controller.isClosed) _controller.add(comments);
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

class GetCommentsParams {
  final String targetId;

  GetCommentsParams(this.targetId);
}
