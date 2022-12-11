import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';

class LikePost extends UseCase<void, LikePostParams> {
  final PostRepository _postRepository;

  LikePost(this._postRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    StreamController<void> controller = StreamController();
    try {
      _postRepository.likePost(params!.postId);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error);
    }
    return controller.stream;
  }
}

class LikePostParams {
  final String postId;

  LikePostParams(this.postId);
}
