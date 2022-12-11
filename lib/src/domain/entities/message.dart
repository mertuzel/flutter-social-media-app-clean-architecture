import 'package:friend_zone/src/domain/entities/user.dart';

class Message {
  final User from;
  final User to;
  final DateTime time;
  final String text;

  Message({
    required this.from,
    required this.to,
    required this.time,
    required this.text,
  });

  Map<String, dynamic> toJson(List<String> userIds) {
    return {
      'from': from.toJsonForMessage(),
      'to': to.toJsonForMessage(),
      'time': time.millisecondsSinceEpoch,
      'text': text,
      'users': userIds,
    };
  }

  Message.fromJson(Map<String, dynamic> json)
      : from = User.fromJsonForMessage(json['from']),
        to = User.fromJsonForMessage(json['to']),
        time = DateTime.fromMillisecondsSinceEpoch(json['time']),
        text = json['text'];
}
