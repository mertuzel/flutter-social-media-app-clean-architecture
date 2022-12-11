import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/home/home_presenter.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class HomeController extends Controller {
  final HomePresenter _presenter;

  HomeController(
    PostRepository postRepository,
    UserRepository userRepository,
  ) : _presenter = HomePresenter(
          postRepository,
          userRepository,
        );

  UnmodifiableListView<Post> posts = UnmodifiableListView([]);
  List<String>? watchlist;

  String lastLikedPost = "";

  int page = 1;
  bool isAllPostsFetched = false;
  bool postsInitialized = false;
  ScrollController scrollController = ScrollController();

  StreamController<bool?> refreshStreamController =
      StreamController.broadcast();

  @override
  void onInitState() {
    _presenter.getPosts();

    super.onInitState();
  }

  @override
  void initListeners() {
    _presenter.getPostsOnNext = (UnmodifiableListView<Post>? response) async {
      if (response == null) return;

      Future.delayed(Duration.zero).then((value) {
        KNavigator.changeLoadingStatus(false);
      });

      if (response.isEmpty || response.length / page < 5) {
        isAllPostsFetched = true;
      }

      page++;
      posts = response;

      if (!postsInitialized) {
        postsInitialized = true;
      }

      refreshUI();
    };

    _presenter.getPostsOnError = (e) {};

    _presenter.likePostOnComplete = () {};

    _presenter.likePostOnError = (e) {};

    _presenter.cancelPostLikeOnComplete = () {};

    _presenter.cancelPostLikeOnError = (e) {};

    _presenter.getNextPostsOnComplete = () {};

    _presenter.getNextPostsOnError = (e) {};

    _presenter.toggleFavoriteStatusOnComplete = () {};

    _presenter.toggleFavoriteStatusOnError = (e) {};
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

  void getNextPosts() {
    if (!isAllPostsFetched) _presenter.getNextPosts();
  }

  void togglePostFavoriteState(Post post) {
    _presenter.toggleFavoriteState(post);
  }

  void getPosts() {
    postsInitialized = false;
    page = 1;
    isAllPostsFetched = false;
    posts = UnmodifiableListView([]);
    refreshUI();
    _presenter.getPosts();
  }
}
