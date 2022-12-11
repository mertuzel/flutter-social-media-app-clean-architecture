import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/comment.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/add_comment.dart';
import 'package:friend_zone/src/domain/usecases/get_comments.dart';
import 'package:friend_zone/src/domain/usecases/get_next_comments.dart';
import 'package:friend_zone/src/domain/usecases/remove_comment.dart';

class CommentsPresenter extends Presenter {
  late Function removeCommentOnComplete;
  late Function removeCommentOnError;

  late Function getCommentsOnNext;
  late Function getCommentsOnError;

  late Function getNextCommentsOnComplete;
  late Function getNextCommentsOnError;

  late Function addCommentOnComplete;
  late Function addCommentOnError;

  final RemoveComment _removeComment;
  final GetComments _getComments;
  final GetNextComments _getNextComments;
  final AddComment _addComment;

  CommentsPresenter(
    PostRepository postRepository,
    UserRepository userRepository,
  )   : _removeComment = RemoveComment(postRepository),
        _getComments = GetComments(postRepository),
        _addComment = AddComment(postRepository, userRepository),
        _getNextComments = GetNextComments(postRepository);

  void removeComment(String postId, String commentId) {
    _removeComment.execute(
        _RemoveCommentObserver(this), RemoveCommentParams(postId, commentId));
  }

  void getComments(String targetId) {
    _getComments.execute(
        _GetCommentsObserver(this), GetCommentsParams(targetId));
  }

  void getNextComments(String targetId) {
    _getNextComments.execute(
        _GetNextCommentsObserver(this), GetNextCommentsParams(targetId));
  }

  void addComment(Comment comment) {
    _addComment.execute(_AddCommentObserver(this), AddCommentParams(comment));
  }

  @override
  void dispose() {
    _getComments.dispose();
    _getNextComments.dispose();
    _removeComment.dispose();
    _addComment.dispose();
  }
}

class _RemoveCommentObserver extends Observer<void> {
  final CommentsPresenter _presenter;

  _RemoveCommentObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.removeCommentOnComplete();
  }

  @override
  void onError(e) {
    _presenter.removeCommentOnError(e);
  }

  @override
  void onNext(_) {}
}

class _AddCommentObserver extends Observer<void> {
  final CommentsPresenter _presenter;

  _AddCommentObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.addCommentOnComplete();
  }

  @override
  void onError(e) {
    _presenter.addCommentOnError(e);
  }

  @override
  void onNext(_) {}
}

class _GetCommentsObserver extends Observer<UnmodifiableListView<Comment>> {
  final CommentsPresenter _presenter;

  _GetCommentsObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getCommentsOnError(e);
  }

  @override
  void onNext(UnmodifiableListView<Comment>? response) {
    _presenter.getCommentsOnNext(response);
  }
}

class _GetNextCommentsObserver extends Observer<void> {
  final CommentsPresenter _presenter;

  _GetNextCommentsObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getNextCommentsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getNextCommentsOnError(e);
  }

  @override
  void onNext(_) {}
}
