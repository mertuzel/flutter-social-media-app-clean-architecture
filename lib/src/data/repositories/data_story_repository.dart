import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friend_zone/src/domain/entities/story.dart';
import 'package:friend_zone/src/domain/entities/story_item.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'dart:collection';

import 'package:friend_zone/src/domain/repositories/story_repository.dart';

class DataStoryRepository implements StoryRepository {
  static DataStoryRepository? _instance;
  DataStoryRepository._();
  factory DataStoryRepository() {
    _instance ??= DataStoryRepository._();

    return _instance!;
  }

  @override
  void killInstance() {
    _instance = null;
  }

  StreamController<UnmodifiableListView<Story>?> _streamController =
      StreamController.broadcast();

  List<Story>? _stories;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  bool get allStoriesSeen => throw UnimplementedError();

  @override
  Stream<UnmodifiableListView<Story>?> getStories(User user) {
    try {
      _stories = null;
      Future.delayed(Duration.zero).then((_) => _streamController
          .add(_stories == null ? null : UnmodifiableListView(_stories!)));

      if (_stories == null) _initStories(user);

      return _streamController.stream;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  void _initStories(User currentUser) async {
    try {
      _stories = [];

      final querySnapshot = await _firestore.collection('stories').get();

      if (querySnapshot.docs.isNotEmpty) {
        await Future.forEach(querySnapshot.docs,
            (QueryDocumentSnapshot<Map<String, dynamic>> element) async {
          final querySnap2 = await _firestore
              .collection('stories')
              .doc(element.id)
              .collection('items')
              .get();

          final doc =
              await _firestore.collection('users').doc(element.id).get();

          User user = User.fromJson(doc.data()!, doc.id);

          List<StoryItem> storyItems = [];

          querySnap2.docs.forEach((element2) {
            StoryItem storyItem = StoryItem.fromJson(
              element2.data(),
              element2.id,
            );
            if (currentUser.seenStoryItemIds.contains(storyItem.id))
              storyItem.isSeen = true;
            storyItems.add(storyItem);
          });

          _stories!.add(
            Story(
                id: element.id,
                items: storyItems,
                publisherLogoUrl: '',
                publisherName: user.firstName + ' ' + user.lastName),
          );
        });

        _stories!.sort((a, b) {
          if (a.items.any((item) => item.isSeen == false) &&
              b.items.any((item) => item.isSeen == false)) {
            return b.items.last.sharedOn.compareTo(a.items.last.sharedOn);
          } else
            return a.items.last.sharedOn.compareTo(b.items.last.sharedOn);
        });

        _stories!.sort((b, a) {
          if (b.items.every((item) => item.isSeen == true)) {
            return 1;
          } else {
            return -1;
          }
        });
      }

      _streamController.add(UnmodifiableListView<Story>(_stories!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> setStoryItemAsSeen(
      User user, String storyId, String storyItemId) async {
    try {
      _firestore.collection('users').doc(user.id).set({
        'seenStoryItemIds': FieldValue.arrayUnion([storyItemId])
      }, SetOptions(merge: true));

      user.seenStoryItemIds.add(storyItemId);
      _stories!
          .firstWhere((element) => element.id == storyId)
          .items
          .firstWhere((element2) => element2.id == storyItemId)
          .isSeen = true;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> addStory(
      {required User user, required StoryItem storyItem}) async {
    try {
      await _firestore
          .collection('stories')
          .doc(user.id)
          .set({'story': 'story'});

      final doc = await _firestore
          .collection('stories')
          .doc(user.id)
          .collection('items')
          .add(
            storyItem.toJson(),
          );

      storyItem.id = doc.id;

      if (_stories!.indexWhere((element) => element.id == user.id) == -1) {
        _stories!.add(
          Story(
            id: user.id,
            items: [storyItem],
            publisherLogoUrl: '',
            publisherName: user.firstName + ' ' + user.lastName,
          ),
        );
      } else {
        _stories!
            .firstWhere((element) => element.id == user.id)
            .items
            .add(storyItem);
      }

      _streamController.add(UnmodifiableListView(_stories!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
