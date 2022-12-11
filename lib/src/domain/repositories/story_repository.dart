import 'dart:collection';

import 'package:friend_zone/src/domain/entities/story.dart';
import 'package:friend_zone/src/domain/entities/story_item.dart';
import 'package:friend_zone/src/domain/entities/user.dart';

abstract class StoryRepository {
  void killInstance();

  Future<void> setStoryItemAsSeen(
    User user,
    String storyId,
    String storyItemId,
  );

  Stream<UnmodifiableListView<Story>?> getStories(User user);
  bool get allStoriesSeen;

  Future<void> addStory({
    required User user,
    required StoryItem storyItem,
  });
}
