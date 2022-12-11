import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/pages/story/story_presenter.dart';
import 'package:friend_zone/src/domain/entities/story.dart';
import 'package:friend_zone/src/domain/entities/story_item.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

import 'package:story_view/story_view.dart' as sw;

class StoryController extends Controller {
  final StoryPresenter _presenter;

  StoryController(
    StoryRepository storyRepository,
    UserRepository userRepository,
    this.story,
  )   : _presenter = StoryPresenter(
          storyRepository,
          userRepository,
        ),
        initialIndex = story.items.indexWhere((item) => !item.isSeen);

  sw.StoryController storyController = sw.StoryController();

  Story story;
  StoryItem? currentStory;
  int initialIndex;

  bool isPopped = false;

  bool isAdVisible = false;
  bool isAdSeen = false;
  bool pausedManually = false;

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    _presenter.setStoryItemAsSeenOnComplete = () {};

    _presenter.setStoryItemAsSeenOnError = (e) {};
  }

  void setStoryAsSeen(String storyId, String storyItemId) {
    _presenter.setStoryItemAsSeen(storyId, storyItemId);
  }

  void closePage() {
    if (!isPopped) Navigator.of(getContext()).pop();
    isPopped = true;
  }

  void refreshScreen() {
    refreshUI();
  }
}
