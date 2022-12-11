import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class TogglePostFavoriteStatus
    extends UseCase<void, TogglePostFavoriteStatusParams> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;

  TogglePostFavoriteStatus(
    this._postRepository,
    this._userRepository,
  );

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    StreamController<void> controller = StreamController();
    try {
      User user = _userRepository.currentUser;

      await _postRepository.toggleFavoriteState(
        uid: user.id,
        postId: params!.postId,
        favorite: params.favorite,
      );

      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class TogglePostFavoriteStatusParams {
  final String postId;
  final bool favorite;

  TogglePostFavoriteStatusParams(this.postId, this.favorite);
}
