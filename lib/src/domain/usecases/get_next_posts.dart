import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';

class GetNextPosts extends UseCase<void, void> {
  final PostRepository _postRepository;

  GetNextPosts(
    this._postRepository,
  );

  @override
  Future<Stream<void>> buildUseCaseStream(void params) async {
    StreamController<void> controller = StreamController();
    try {
      await _postRepository.getNextPosts();
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}
