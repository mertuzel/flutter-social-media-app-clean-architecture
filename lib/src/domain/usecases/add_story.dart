import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/story_item.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class AddStory extends UseCase<void, AddStoryParams> {
  final StoryRepository _storyRepository;
  final UserRepository _userRepository;

  AddStory(
    this._storyRepository,
    this._userRepository,
  );

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    StreamController<void> controller = StreamController();
    try {
      User user = _userRepository.currentUser;

      await _storyRepository.addStory(storyItem: params!.storyItem, user: user);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error);
    }
    return controller.stream;
  }
}

class AddStoryParams {
  final StoryItem storyItem;

  AddStoryParams(this.storyItem);
}
