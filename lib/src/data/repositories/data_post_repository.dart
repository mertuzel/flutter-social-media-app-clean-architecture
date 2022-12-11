import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:friend_zone/src/domain/entities/comment.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:collection/collection.dart';

import 'package:friend_zone/src/domain/repositories/post_repository.dart';

class DataPostRepository implements PostRepository {
  static DataPostRepository? _instance;
  DataPostRepository._();
  factory DataPostRepository() {
    _instance ??= DataPostRepository._();

    return _instance!;
  }

  StreamController<UnmodifiableListView<Post>?> _postsStreamController =
      StreamController.broadcast();

  StreamController<UnmodifiableListView<Post>?>
      _favoritedPostsStreamController = StreamController.broadcast();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StreamController<UnmodifiableListView<Comment>?>
      _commentsStreamController = StreamController.broadcast();

  QueryDocumentSnapshot<Map<String, dynamic>>? _lastCommentDocument;
  QueryDocumentSnapshot<Map<String, dynamic>>? _lastPostDocument;

  List<Comment>? comments;

  List<Post>? _posts;
  List<Post> _favoritedPosts = [];
  Set<String> likedPostIds = {};
  Set<String> favoritesPostIds = {};

  bool isFavoritePostsInitialized = false;

  @override
  void killInstance() {
    _instance = null;
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      if (likedPostIds.contains(postId)) return;

      final doc = await _firestore.collection('posts').doc(postId).get();

      _firestore.collection('posts').doc(postId).update({
        'numberOfLikes': doc.data()!['numberOfLikes'] + 1,
      });

      _firestore
          .collection('users')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .update({
        'likedPostIds': FieldValue.arrayUnion([postId])
      });

      likedPostIds.add(postId);
      Post? post = _posts!.firstWhereOrNull((post) => post.id == postId);
      if (post != null) {
        post.numberOfLikes++;
        post.isLiked = true;
      }

      Post? favoritePost =
          _favoritedPosts.firstWhereOrNull((post) => post.id == postId);

      if (favoritePost != null) {
        favoritePost.numberOfLikes++;
        favoritePost.isLiked = true;
      }

      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));
      _favoritedPosts.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));
      _favoritedPostsStreamController
          .add(UnmodifiableListView(_favoritedPosts));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> cancelPostLike(String postId) async {
    try {
      if (!likedPostIds.contains(postId)) return;

      final doc = await _firestore.collection('posts').doc(postId).get();

      _firestore.collection('posts').doc(postId).update({
        'numberOfLikes': doc.data()!['numberOfLikes'] - 1,
      });

      _firestore
          .collection('users')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .update({
        'likedPostIds': FieldValue.arrayRemove([postId])
      });

      likedPostIds.remove(postId);
      Post? post = _posts!.firstWhereOrNull((post) => post.id == postId);
      if (post != null) {
        post.numberOfLikes--;
        post.isLiked = false;
      }

      Post? favoritePost =
          _favoritedPosts.firstWhereOrNull((post) => post.id == postId);

      if (favoritePost != null) {
        favoritePost.numberOfLikes--;
        favoritePost.isLiked = false;
      }

      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));
      _favoritedPosts.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));
      _favoritedPostsStreamController
          .add(UnmodifiableListView(_favoritedPosts));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> getNextPosts() async {
    try {
      if (_lastPostDocument == null) {
        _postsStreamController.add(UnmodifiableListView([]));

        return;
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('posts')
          .limit(5)
          .orderBy('publishedOn', descending: true)
          .startAfterDocument(_lastPostDocument!)
          .get();

      _posts ??= [];

      if (querySnapshot.docs.isNotEmpty) {
        _lastPostDocument = querySnapshot.docs.last;

        await Future.forEach(querySnapshot.docs,
            (QueryDocumentSnapshot<Map<String, dynamic>> element) async {
          Post post = Post.fromJson(element.data(), element.id);

          final snapshot = await _firestore
              .collection('commentCounts')
              .doc(element.id)
              .get();

          if (snapshot.data() != null) {
            post.numberOfComments = snapshot.data()!['total'];
          }

          if (likedPostIds.contains(element.id)) {
            post.isLiked = true;
          }

          if (favoritesPostIds.contains(element.id)) {
            post.isFavorited = true;
          }
          _posts!.add(post);
        });
      }

      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));
      _postsStreamController.add(UnmodifiableListView(_posts!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Stream<UnmodifiableListView<Post>?> getPosts(User user) {
    try {
      likedPostIds = user.likedPostIds;
      favoritesPostIds = user.favoritedPostIds;

      _posts = null;
      _lastPostDocument = null;

      _initPosts();

      Future.delayed(Duration.zero).then((_) {
        if (_posts == null) {
          _postsStreamController.add(null);
        } else {
          _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

          _postsStreamController.add(UnmodifiableListView(_posts!));
        }
      });

      return _postsStreamController.stream;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> addPost(Post post) async {
    try {
      final doc = await _firestore.collection('posts').add(post.toJson());
      if (_posts == null) {
        _posts = [];
      }
      post.id = doc.id;

      _posts!.add(post);
      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> addComment(Comment comment) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('comments')
          .add((comment).toJson());

      Comment _comment = Comment(
        id: doc.id,
        authorId: comment.authorId,
        authorName: comment.authorName,
        sharedOn: comment.sharedOn,
        targetId: comment.targetId,
        text: comment.text,
      );

      _firestore.collection('commentCounts').doc(comment.targetId).set(
        {
          'total': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );

      Post? post =
          _posts!.firstWhereOrNull((element) => element.id == comment.targetId);

      if (post != null) {
        post.numberOfComments++;
      }

      Post? favPost = _favoritedPosts
          .firstWhereOrNull((element) => element.id == comment.targetId);

      if (favPost != null) {
        favPost.numberOfComments++;
      }
      comments ??= [];

      comments!.add(_comment);

      comments!.sort((a, b) => b.sharedOn.compareTo(a.sharedOn));

      _commentsStreamController.add(UnmodifiableListView(comments!));
      _postsStreamController.add(UnmodifiableListView(_posts!));
      _favoritedPostsStreamController
          .add(UnmodifiableListView(_favoritedPosts));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Stream<UnmodifiableListView<Comment>?> getComments(String targetId) {
    try {
      comments = null;
      _lastCommentDocument = null;

      _initComments(targetId);

      Future.delayed(Duration.zero).then((_) {
        if (comments == null) {
          _commentsStreamController.add(null);
        } else {
          comments!.sort((a, b) => b.sharedOn.compareTo(a.sharedOn));

          _commentsStreamController.add(UnmodifiableListView(comments!));
        }
      });

      return _commentsStreamController.stream;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  void _initPosts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('posts')
          .orderBy('publishedOn', descending: true)
          .limit(5)
          .get();

      _posts ??= [];

      if (querySnapshot.docs.isNotEmpty) {
        _lastPostDocument = querySnapshot.docs.last;

        await Future.forEach(querySnapshot.docs,
            (QueryDocumentSnapshot<Map<String, dynamic>> element) async {
          Post post = Post.fromJson(element.data(), element.id);

          final snapshot = await _firestore
              .collection('commentCounts')
              .doc(element.id)
              .get();

          if (snapshot.data() != null) {
            post.numberOfComments = snapshot.data()!['total'];
          }

          if (likedPostIds.contains(element.id)) {
            post.isLiked = true;
          }

          if (favoritesPostIds.contains(element.id)) {
            post.isFavorited = true;
          }
          _posts!.add(post);
        });
      }

      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  void _initComments(String targetId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('comments')
          .where('targetId', isEqualTo: targetId)
          .orderBy('sharedOn', descending: true)
          .limit(10)
          .get();

      comments ??= [];

      if (querySnapshot.docs.isNotEmpty) {
        _lastCommentDocument = querySnapshot.docs.last;

        querySnapshot.docs.forEach((doc) {
          comments!.add(Comment.fromJson(doc));
        });
      }

      comments!.sort((a, b) => b.sharedOn.compareTo(a.sharedOn));

      _commentsStreamController.add(UnmodifiableListView(comments!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<bool> getNextComments(String targetId) async {
    try {
      if (_lastCommentDocument == null) {
        _commentsStreamController.add(UnmodifiableListView([]));

        return true;
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('comments')
          .where('targetId', isEqualTo: targetId)
          .limit(10)
          .orderBy('sharedOn', descending: true)
          .startAfterDocument(_lastCommentDocument!)
          .get();

      comments ??= [];

      if (querySnapshot.docs.isNotEmpty) {
        _lastCommentDocument = querySnapshot.docs.last;

        querySnapshot.docs.forEach((doc) {
          comments!.add(Comment.fromJson(doc));
        });

        comments!.sort((a, b) => b.sharedOn.compareTo(a.sharedOn));

        _commentsStreamController.add(UnmodifiableListView(comments!));
        return false;
      } else {
        _commentsStreamController.add(UnmodifiableListView(comments!));
        return true;
      }
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> removeComment(String postId, String commentId) async {
    try {
      await _firestore.collection('comments').doc(commentId).delete();

      await _firestore.collection('commentCounts').doc(postId).update({
        'total': FieldValue.increment(-1),
      });

      comments!.removeWhere((element) => element.id == commentId);

      Post? post = _posts!.firstWhereOrNull((element) => element.id == postId);

      if (post != null) {
        post.numberOfComments--;
      }

      Post? favPost =
          _favoritedPosts.firstWhereOrNull((element) => element.id == postId);

      if (favPost != null) {
        favPost.numberOfComments--;
      }

      comments!.sort((a, b) => b.sharedOn.compareTo(a.sharedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));

      _commentsStreamController.add(UnmodifiableListView(comments!));
      _favoritedPostsStreamController
          .add(UnmodifiableListView(_favoritedPosts));

      return null;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> toggleFavoriteState({
    required String uid,
    required String postId,
    required bool favorite,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'favoritedPostIds': favorite
            ? FieldValue.arrayUnion(
                [postId],
              )
            : FieldValue.arrayRemove([postId]),
      }, SetOptions(merge: true));

      if (favorite) {
        Post post = _posts!.firstWhere((element) => element.id == postId);
        post.isFavorited = true;

        Post favoritedPost = post.copy();
        favoritesPostIds.add(postId);
        _favoritedPosts.add(favoritedPost);
      } else {
        Post? post =
            _posts!.firstWhereOrNull((element) => element.id == postId);

        if (post != null) {
          post.isFavorited = false;
        }

        _favoritedPosts.removeWhere((element) => element.id == post!.id);

        favoritesPostIds.remove(postId);
      }

      _favoritedPostsStreamController
          .add(UnmodifiableListView(_favoritedPosts));

      _postsStreamController.add(UnmodifiableListView(_posts!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Stream<UnmodifiableListView<Post>?> getFavoritedPosts(User user) {
    try {
      _initFavoritedPosts();

      Future.delayed(Duration.zero).then((_) {
        if (!isFavoritePostsInitialized) {
          _favoritedPostsStreamController.add(null);
        } else {
          _favoritedPosts
              .sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

          _favoritedPostsStreamController
              .add(UnmodifiableListView(_favoritedPosts));
        }
      });

      return _favoritedPostsStreamController.stream;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  void _initFavoritedPosts() async {
    try {
      await Future.forEach(favoritesPostIds, (String element) async {
        final doc = await _firestore.collection('posts').doc(element).get();

        if (doc.data() != null) {
          Post post = Post.fromJson(doc.data()!, doc.id);
          if (_favoritedPosts.indexWhere((element) => element.id == post.id) ==
              -1) {
            post.isFavorited = true;
            final snapshot =
                await _firestore.collection('commentCounts').doc(post.id).get();

            if (snapshot.data() != null) {
              post.numberOfComments = snapshot.data()!['total'];
            }
            if (likedPostIds.contains(post.id)) {
              post.isLiked = true;
            }
            _favoritedPosts.add(post);
          }
        }
      });

      _favoritedPostsStreamController
          .add(UnmodifiableListView(_favoritedPosts));

      isFavoritePostsInitialized = true;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
