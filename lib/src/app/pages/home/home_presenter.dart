import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/cancel_post_like.dart';
import 'package:friend_zone/src/domain/usecases/get_next_posts.dart';
import 'package:friend_zone/src/domain/usecases/get_posts.dart';
import 'package:friend_zone/src/domain/usecases/like_post.dart';
import 'package:friend_zone/src/domain/usecases/toggle_post_favorite_state.dart';

class HomePresenter extends Presenter {
  late Function getPostsOnNext;
  late Function getPostsOnError;

  late Function likePostOnComplete;
  late Function likePostOnError;

  late Function cancelPostLikeOnComplete;
  late Function cancelPostLikeOnError;

  late Function getNextPostsOnComplete;
  late Function getNextPostsOnError;

  late Function toggleFavoriteStatusOnComplete;
  late Function toggleFavoriteStatusOnError;

  final GetPosts _getPosts;
  final CancelPostLike _cancelPostLike;
  final LikePost _likePost;
  final GetNextPosts _getNextPosts;
  final TogglePostFavoriteStatus _togglePostFavoriteStatus;

  HomePresenter(PostRepository postRepository, UserRepository userRepository)
      : _getPosts = GetPosts(postRepository, userRepository),
        _likePost = LikePost(postRepository),
        _cancelPostLike = CancelPostLike(postRepository),
        _togglePostFavoriteStatus = TogglePostFavoriteStatus(
          postRepository,
          userRepository,
        ),
        _getNextPosts = GetNextPosts(postRepository);

  void getPosts() {
    _getPosts.execute(
      _GetPostsObserver(this),
    );
  }

  void likePost(String postId) {
    _likePost.execute(_LikePostObserver(this), LikePostParams(postId));
  }

  void cancelPostLike(String postId) {
    _cancelPostLike.execute(
        _CancelPostLikeObserver(this), CancelPostLikeParams(postId));
  }

  void getNextPosts() {
    _getNextPosts.execute(_GetNextPostsObserver(this));
  }

  void toggleFavoriteState(Post post) {
    _togglePostFavoriteStatus.execute(
        _TogglePostFavoriteStateObserver(this),
        TogglePostFavoriteStatusParams(
          post.id,
          post.isFavorited ? false : true,
        ));
  }

  @override
  void dispose() {
    _getPosts.dispose();
    _likePost.dispose();
    _cancelPostLike.dispose();
    _getNextPosts.dispose();
    _togglePostFavoriteStatus.dispose();
  }
}

class _GetPostsObserver extends Observer<UnmodifiableListView<Post>?> {
  final HomePresenter _presenter;

  _GetPostsObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getPostsOnError(e);
  }

  @override
  void onNext(UnmodifiableListView<Post>? response) {
    _presenter.getPostsOnNext(response);
  }
}

class _GetNextPostsObserver extends Observer<void> {
  final HomePresenter _presenter;

  _GetNextPostsObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getNextPostsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getNextPostsOnError(e);
  }

  @override
  void onNext(_) {}
}

class _LikePostObserver extends Observer<void> {
  final HomePresenter _presenter;

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
  final HomePresenter _presenter;

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
  final HomePresenter _presenter;

  _TogglePostFavoriteStateObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.toggleFavoriteStatusOnComplete();
  }

  @override
  void onError(e) {
    _presenter.toggleFavoriteStatusOnError(e);
  }

  @override
  void onNext(_) {}
}
