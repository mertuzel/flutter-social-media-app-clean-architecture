import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/usecases/add_post.dart';

class AddPostPresenter extends Presenter {
  late Function addPostOnComplete;
  late Function addPostOnError;

  final AddPost _addPost;

  AddPostPresenter(
    PostRepository postRepository,
    UserRepository userRepository,
  ) : _addPost = AddPost(postRepository, userRepository);

  void addPost(Post post) {
    _addPost.execute(
      _AddPostObserver(this),
      AddPostParams(post),
    );
  }

  @override
  void dispose() {
    _addPost.dispose();
  }
}

class _AddPostObserver extends Observer<void> {
  final AddPostPresenter _presenter;

  _AddPostObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.addPostOnComplete();
  }

  @override
  void onError(e) {
    _presenter.addPostOnError(e);
  }

  @override
  void onNext(_) {}
}
