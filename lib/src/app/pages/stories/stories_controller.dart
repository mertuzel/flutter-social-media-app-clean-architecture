import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/pages/stories/stories_presenter.dart';
import 'package:friend_zone/src/domain/entities/story.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class StoriesController extends Controller {
  final StoriesPresenter _presenter;

  StoriesController(
    StoryRepository storyRepository,
    UserRepository userRepository,
    this.refresh,
  ) : _presenter = StoriesPresenter(
          storyRepository,
          userRepository,
        );

  bool _isStoryLoading = false;

  UnmodifiableListView<Story>? stories;

  Stream<bool?> refresh;

  void getStories() {
    stories = null;
    refreshUI();
    _presenter.getStories();
  }

  @override
  void onInitState() {
    _presenter.getStories();
    refresh.listen((event) {
      if (event == null) return;
      if (event) {
        getStories();
      }
    });
    super.onInitState();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    _presenter.getStoriesOnNext =
        (UnmodifiableListView<Story>? response) async {
      if (response == null) return;

      this.stories = response;

      refreshUI();
    };

    _presenter.getStoriesOnError = (e) {};
  }

  bool get isStoryLoading => _isStoryLoading;

  void changeLoadingStatus(bool value) {
    _isStoryLoading = value;
    refreshUI();
  }

  void refreshScreen() {
    refreshUI();
  }
}
