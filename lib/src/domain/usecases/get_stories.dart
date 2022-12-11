import 'dart:async';
import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/story.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class GetStories extends UseCase<UnmodifiableListView<Story>?, void> {
  final StoryRepository _storyRepository;
  final UserRepository _userRepository;
  final StreamController<UnmodifiableListView<Story>?> _controller;

  GetStories(
    this._storyRepository,
    this._userRepository,
  ) : _controller = StreamController.broadcast();

  @override
  Future<Stream<UnmodifiableListView<Story>?>> buildUseCaseStream(
      void params) async {
    try {
      User user = _userRepository.currentUser;

      _storyRepository
          .getStories(user)
          .listen((UnmodifiableListView<Story>? stories) {
        if (!_controller.isClosed) _controller.add(stories);
      });
    } catch (error, stackTrace) {
      _controller.addError(error);
    }
    return _controller.stream;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
