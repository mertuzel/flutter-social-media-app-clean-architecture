import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class AddPost extends UseCase<void, AddPostParams> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;

  AddPost(
    this._postRepository,
    this._userRepository,
  );

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    StreamController<void> controller = StreamController();
    try {
      User user = _userRepository.currentUser;
      params!.post.publisher = user.firstName + ' ' + user.lastName;
      params.post.publisherId = user.id;

      await _postRepository.addPost(params.post);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error);
    }
    return controller.stream;
  }
}

class AddPostParams {
  final Post post;

  AddPostParams(this.post);
}
