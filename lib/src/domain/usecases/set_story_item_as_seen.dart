import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class SetStoryItemAsSeen extends UseCase<void, SetStoryItemAsSeenParams> {
  final StoryRepository _storyRepository;
  final UserRepository _userRepository;

  SetStoryItemAsSeen(
    this._storyRepository,
    this._userRepository,
  );

  @override
  Future<Stream<void>> buildUseCaseStream(
      SetStoryItemAsSeenParams? params) async {
    StreamController<void> controller = StreamController();
    try {
      User currentUser = _userRepository.currentUser;

      await _storyRepository.setStoryItemAsSeen(
        currentUser,
        params!.storyId,
        params.storyItemId,
      );

      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class SetStoryItemAsSeenParams {
  final String storyId;
  final String storyItemId;

  SetStoryItemAsSeenParams(this.storyId, this.storyItemId);
}
