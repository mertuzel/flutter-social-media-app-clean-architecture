import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friend_zone/src/domain/entities/message.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';

class DataChatRepository implements ChatRepository {
  static DataChatRepository? _instance;
  DataChatRepository._();
  factory DataChatRepository() {
    _instance ??= DataChatRepository._();

    return _instance!;
  }

  @override
  void killInstance() {
    _instance = null;
  }

  StreamController<List<Message>?> _streamController =
      StreamController.broadcast();

  StreamController<List<Message>?> _lastMessagesStreamController =
      StreamController.broadcast();

  List<Message>? messages;
  List<Message>? lastMessages;
  bool isListenLastMessagesInitialized = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late void Function(QuerySnapshot<Map<String, dynamic>?>) listenMessagesFunc;
  late void Function(QuerySnapshot<Map<String, dynamic>?>)
      listenLastMessagesFunc;

  @override
  Stream<List<Message>?> getMessages(List<String> userIds) {
    userIds.sort((a, b) => a.compareTo(b));

    try {
      _listenMessages(userIds);
      Future.delayed(Duration.zero).then(
        (_) => _streamController.add(messages),
      );
      return _streamController.stream;
    } catch (e, st) {
      print(e);
      print(st);
      print('Error on getMessages');
      rethrow;
    }
  }

  void _listenMessages(List<String> userIds) async {
    try {
      final firestoreStream = _firestore
          .collection('messages')
          .where('users', isEqualTo: userIds)
          .orderBy('time', descending: true)
          .snapshots();

      listenMessagesFunc = (event) {
        try {
          messages = [];
          if (event.docs.isEmpty) {
            _streamController.add([]);
            return;
          }
          if (event.docs.isNotEmpty) {
            event.docs.forEach((doc) {
              Message message = Message.fromJson(doc.data()!);
              messages!.add(message);
            });
          }
          messages!.sort((a, b) => a.time.compareTo(b.time));
          _streamController.add(messages);
        } catch (e, st) {
          print(e);
          print(st);
          rethrow;
        }
      };

      firestoreStream.listen(listenMessagesFunc);
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> sendMessage(Message message, List<String> userIds) async {
    userIds.sort((a, b) => a.compareTo(b));
    try {
      await _firestore
          .collection('messages')
          .doc()
          .set(message.toJson(userIds));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Stream<List<Message>?> getLastMessagesOfUser(String userId) {
    try {
      if (!isListenLastMessagesInitialized) {
        _listenLastMessages(userId);
      }
      Future.delayed(Duration.zero).then(
        (_) => _lastMessagesStreamController.add(lastMessages),
      );
      return _lastMessagesStreamController.stream;
    } catch (e, st) {
      print(e);
      print(st);
      print('Error on getOrders');
      rethrow;
    }
  }

  void _listenLastMessages(String userId) async {
    try {
      isListenLastMessagesInitialized = true;
      final firestoreStream = _firestore
          .collection('messages')
          .where('users', arrayContains: userId)
          .orderBy('time', descending: true)
          .limit(1)
          .snapshots();

      listenLastMessagesFunc = (event) {
        try {
          lastMessages = [];

          if (event.docs.isEmpty) {
            _lastMessagesStreamController.add([]);
            return;
          }
          if (event.docs.isNotEmpty) {
            event.docs.forEach((doc) {
              Message message = Message.fromJson(doc.data()!);
              lastMessages!.add(message);
            });
          }
          lastMessages!.sort((a, b) => a.time.compareTo(b.time));
          _lastMessagesStreamController.add(lastMessages);
        } catch (e, st) {
          print(e);
          print(st);
          rethrow;
        }
      };

      firestoreStream.listen(listenLastMessagesFunc);
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
