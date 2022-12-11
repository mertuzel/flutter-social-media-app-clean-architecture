import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/cancel_post_like.dart';
import 'package:friend_zone/src/domain/usecases/get_favorited_posts.dart';
import 'package:friend_zone/src/domain/usecases/like_post.dart';
import 'package:friend_zone/src/domain/usecases/toggle_post_favorite_state.dart';

class FavoritesPresenter extends Presenter {
  late Function getFavoritedPostsOnNext;
  late Function getFavoritedPostsOnError;

  late Function likePostOnComplete;
  late Function likePostOnError;

  late Function cancelPostLikeOnComplete;
  late Function cancelPostLikeOnError;

  late Function removeFromFavoriteOnComplete;
  late Function removeFromFavoriteOnError;

  final GetFavoritedPosts _getFavoritedPosts;
  final LikePost _likePost;
  final CancelPostLike _cancelPostLike;
  final TogglePostFavoriteStatus _togglePostFavoriteStatus;

  FavoritesPresenter(
      PostRepository postRepository, UserRepository userRepository)
      : _getFavoritedPosts = GetFavoritedPosts(postRepository, userRepository),
        _likePost = LikePost(postRepository),
        _cancelPostLike = CancelPostLike(postRepository),
        _togglePostFavoriteStatus =
            TogglePostFavoriteStatus(postRepository, userRepository);

  void getFavoritedPosts() {
    _getFavoritedPosts.execute(
      _GetFavoritedPostsObserver(this),
    );
  }

  void likePost(String postId) {
    _likePost.execute(_LikePostObserver(this), LikePostParams(postId));
  }

  void cancelPostLike(String postId) {
    _cancelPostLike.execute(
        _CancelPostLikeObserver(this), CancelPostLikeParams(postId));
  }

  void toggleFavoriteState(String postId) {
    _togglePostFavoriteStatus.execute(
        _TogglePostFavoriteStateObserver(this),
        TogglePostFavoriteStatusParams(
          postId,
          false,
        ));
  }

  @override
  void dispose() {
    _getFavoritedPosts.dispose();
    _likePost.dispose();
    _cancelPostLike.dispose();
    _togglePostFavoriteStatus.dispose();
  }
}

class _GetFavoritedPostsObserver extends Observer<UnmodifiableListView<Post>?> {
  final FavoritesPresenter _presenter;

  _GetFavoritedPostsObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getFavoritedPostsOnError(e);
  }

  @override
  void onNext(UnmodifiableListView<Post>? response) {
    _presenter.getFavoritedPostsOnNext(response);
  }
}

class _LikePostObserver extends Observer<void> {
  final FavoritesPresenter _presenter;

  _LikePostObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.likePostOnComplete();
  }

  @override
  void onError(e) {
    _presenter.likePostOnError(e);
  }

  @override
  void onNext(_) {}
}

class _CancelPostLikeObserver extends Observer<void> {
  final FavoritesPresenter _presenter;

  _CancelPostLikeObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.cancelPostLikeOnComplete();
  }

  @override
  void onError(e) {
    _presenter.cancelPostLikeOnError(e);
  }

  @override
  void onNext(_) {}
}

class _TogglePostFavoriteStateObserver extends Observer<void> {
  final FavoritesPresenter _presenter;

  _TogglePostFavoriteStateObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.removeFromFavoriteOnComplete();
  }

  @override
  void onError(e) {
    _presenter.removeFromFavoriteOnError(e);
  }

  @override
  void onNext(_) {}
}
