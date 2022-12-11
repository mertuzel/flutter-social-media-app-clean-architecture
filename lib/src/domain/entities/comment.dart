import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String authorId;
  final String authorName;
  final String targetId;
  final String text;
  final DateTime sharedOn;

  Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.targetId,
    required this.text,
    required this.sharedOn,
  });

  Comment.fromJson(DocumentSnapshot<Map<String, dynamic>> json)
      : id = json.id,
        authorId = json['authorId'],
        authorName = json['authorName'],
        targetId = json['targetId'],
        text = json['text'],
        sharedOn = DateTime.fromMillisecondsSinceEpoch(json['sharedOn']);

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'targetId': targetId,
      'text': text,
      'sharedOn': sharedOn.millisecondsSinceEpoch,
    };
  }
}
