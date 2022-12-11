import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/set_story_item_as_seen.dart';

class StoryPresenter extends Presenter {
  late Function setStoryItemAsSeenOnComplete;
  late Function setStoryItemAsSeenOnError;

  final SetStoryItemAsSeen _setStoryItemAsSeen;

  StoryPresenter(
    StoryRepository storyRepository,
    UserRepository userRepository,
  ) : _setStoryItemAsSeen = SetStoryItemAsSeen(
          storyRepository,
          userRepository,
        );

  void setStoryItemAsSeen(String storyId, String storyItemId) {
    _setStoryItemAsSeen.execute(
      _SetStoryItemAsSeenObserver(this),
      SetStoryItemAsSeenParams(storyId, storyItemId),
    );
  }

  @override
  void dispose() {
    _setStoryItemAsSeen.dispose();
  }
}

class _SetStoryItemAsSeenObserver extends Observer<void> {
  final StoryPresenter _presenter;

  _SetStoryItemAsSeenObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.setStoryItemAsSeenOnComplete();
  }

  @override
  void onError(error) {
    _presenter.setStoryItemAsSeenOnError(error);
  }

  @override
  void onNext(_) {}
}
