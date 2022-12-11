import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/story.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/get_stories.dart';

class StoriesPresenter extends Presenter {
  late Function getStoriesOnNext;
  late Function getStoriesOnError;

  GetStories _getStories;

  StoriesPresenter(
    StoryRepository storyRepository,
    UserRepository userRepository,
  ) : _getStories = GetStories(
          storyRepository,
          userRepository,
        );

  void getStories() {
    _getStories.execute(
      _GetStoriesObserver(this),
    );
  }

  @override
  void dispose() {
    _getStories.dispose();
  }
}

class _GetStoriesObserver extends Observer<UnmodifiableListView<Story>?> {
  final StoriesPresenter _presenter;

  _GetStoriesObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(error) {
    _presenter.getStoriesOnError(error);
  }

  @override
  void onNext(UnmodifiableListView<Story>? stories) {
    _presenter.getStoriesOnNext(stories);
  }
}
