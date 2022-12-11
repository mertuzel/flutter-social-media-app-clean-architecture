import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';

class CancelPostLike extends UseCase<void, CancelPostLikeParams> {
  final PostRepository _postRepository;

  CancelPostLike(this._postRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    StreamController<void> controller = StreamController();
    try {
      _postRepository.cancelPostLike(params!.postId);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error);
    }
    return controller.stream;
  }
}

class CancelPostLikeParams {
  final String postId;

  CancelPostLikeParams(this.postId);
}
