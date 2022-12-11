import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/favorites/favorites_presenter.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class FavoritesController extends Controller {
  final FavoritesPresenter _presenter;

  FavoritesController(
      PostRepository postRepository, UserRepository userRepository)
      : _presenter = FavoritesPresenter(postRepository, userRepository);

  UnmodifiableListView<Post>? posts;
  String lastLikedPost = "";
  ScrollController scrollController = ScrollController();

  @override
  void onInitState() {
    Future.delayed(Duration.zero).then((value) {
      KNavigator.changeLoadingStatus(true);
    });

    _presenter.getFavoritedPosts();
    super.onInitState();
  }

  @override
  void initListeners() {
    _presenter.getFavoritedPostsOnNext =
        (UnmodifiableListView<Post>? response) async {
      if (response == null) return;

      posts = response;
      refreshUI();

      Future.delayed(Duration.zero).then((value) {
        KNavigator.changeLoadingStatus(false);
      });
    };

    _presenter.getFavoritedPostsOnError = (e) {};

    _presenter.likePostOnComplete = () {};

    _presenter.likePostOnError = (e) {};

    _presenter.cancelPostLikeOnComplete = () {};

    _presenter.cancelPostLikeOnError = (e) {};

    _presenter.removeFromFavoriteOnComplete = () {};

    _presenter.removeFromFavoriteOnError = (e) {};
  }

  void changePostLike(Post post) async {
    if (post.isLiked) {
      _presenter.cancelPostLike(post.id);
    } else {
      kVibrateLight();
      _presenter.likePost(post.id);

      lastLikedPost = post.id;
      refreshUI();

      Future.delayed(Duration(milliseconds: 1000)).then((_) {
        lastLikedPost = "";
        refreshUI();
      });
    }
  }

  void removeFromFavorite(Post post) {
    _presenter.toggleFavoriteState(post.id);
  }
}
