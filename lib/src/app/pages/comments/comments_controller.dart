import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/comments/comments_presenter.dart';
import 'package:friend_zone/src/app/widgets/add_comment_widget.dart';
import 'package:friend_zone/src/domain/entities/comment.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';

class CommentsController extends Controller {
  final CommentsPresenter _presenter;

  CommentsController(
    PostRepository postRepository,
    UserRepository userRepository,
    this.postId,
  ) : _presenter = CommentsPresenter(
          postRepository,
          userRepository,
        );

  String postId;
  UnmodifiableListView<Comment> comments = UnmodifiableListView([]);
  bool commentsInitializedFirstTime = false;

  int page = 1;
  bool isAllCommentsFetched = false;

  @override
  void onInitState() {
    Future.delayed(Duration.zero).then((value) {
      KNavigator.changeLoadingStatus(true);
    });
    _presenter.getComments(postId);
    super.onInitState();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    _presenter.removeCommentOnComplete = () {
      Future.delayed(Duration.zero).then((_) {
        KNavigator.changeLoadingStatus(false);
      });
    };

    _presenter.removeCommentOnError = (e) {};

    _presenter.getCommentsOnNext = (UnmodifiableListView<Comment>? response) {
      if (response == null) return;

      if (response.isEmpty || response.length / page < 10) {
        isAllCommentsFetched = true;
      }

      if (!commentsInitializedFirstTime) {
        commentsInitializedFirstTime = true;
      }

      page++;
      comments = response;

      refreshUI();
      Future.delayed(Duration.zero).then((value) {
        KNavigator.changeLoadingStatus(false);
      });
    };

    _presenter.getCommentsOnError = (e) {};

    _presenter.getNextCommentsOnComplete = () {};

    _presenter.getNextCommentsOnError = (e) {};

    _presenter.addCommentOnComplete = () {
      Future.delayed(Duration.zero).then((_) {
        KNavigator.changeLoadingStatus(false);
      });
    };

    _presenter.addCommentOnError = (e) {};
  }

  void getNextComments() {
    if (!isAllCommentsFetched) _presenter.getNextComments(postId);
  }

  void removeComment(String commentId) {
    Future.delayed(Duration.zero).then((_) {
      KNavigator.changeLoadingStatus(true);
    });

    _presenter.removeComment(postId, commentId);
  }

  void openAddComment() async {
    String? text = await showDialog(
      context: getContext(),
      builder: (context) => AddCommentWidget(),
    );

    if (text == null) return;

    Future.delayed(Duration.zero).then((_) {
      KNavigator.changeLoadingStatus(true);
    });

    _presenter.addComment(Comment(
      id: '',
      authorId: '',
      authorName: '',
      targetId: postId,
      text: text,
      sharedOn: DateTime.now(),
    ));
  }
}
