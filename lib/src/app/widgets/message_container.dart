import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/data/utils/string_utils.dart';
import 'package:friend_zone/src/domain/entities/message.dart';

class MessageContainer extends StatefulWidget {
  final Message message;

  MessageContainer(this.message)
      : isCurrentUser =
            message.from.id == FirebaseAuth.instance.currentUser!.uid;

  final bool isCurrentUser;

  @override
  State<MessageContainer> createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
      },
      child: Column(
        crossAxisAlignment: widget.isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (isTapped)
            Text(
              StringUtils.getPublishDateLong(widget.message.time),
              style: k10w400AxiBlackBottomText(color: kDot),
            ),
          Row(
            mainAxisAlignment: widget.isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(minHeight: 20),
                  decoration: BoxDecoration(
                    color: widget.isCurrentUser ? kSecondary : kPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 7),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    widget.message.text,
                    style: k13w300AxiWhiteProfileHeaderText(color: kWhite),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
