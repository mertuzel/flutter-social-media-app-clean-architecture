import 'dart:async';
import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class GetFavoritedPosts extends UseCase<UnmodifiableListView<Post>?, void> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;
  final StreamController<UnmodifiableListView<Post>?> _controller;

  GetFavoritedPosts(
    this._postRepository,
    this._userRepository,
  ) : _controller = StreamController.broadcast();

  @override
  Future<Stream<UnmodifiableListView<Post>?>> buildUseCaseStream(params) async {
    try {
      User user = _userRepository.currentUser;
      _postRepository
          .getFavoritedPosts(user)
          .listen((UnmodifiableListView<Post>? posts) {
        if (!_controller.isClosed) _controller.add(posts);
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
