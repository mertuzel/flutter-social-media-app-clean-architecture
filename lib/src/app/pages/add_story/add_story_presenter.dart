import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/story_item.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/add_story.dart';

class AddStoryPresenter extends Presenter {
  late Function addStoryOnComplete;
  late Function addStoryOnError;

  final AddStory _addStory;

  AddStoryPresenter(
    StoryRepository storyRepository,
    UserRepository userRepository,
  ) : _addStory = AddStory(
          storyRepository,
          userRepository,
        );

  void addStory(StoryItem storyItem) {
    _addStory.execute(
      _AddStoryObserver(this),
      AddStoryParams(storyItem),
    );
  }

  @override
  void dispose() {
    _addStory.dispose();
  }
}

class _AddStoryObserver extends Observer<void> {
  final AddStoryPresenter _presenter;

  _AddStoryObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.addStoryOnComplete();
  }

  @override
  void onError(e) {
    _presenter.addStoryOnError(e);
  }

  @override
  void onNext(_) {}
}
