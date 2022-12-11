import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/chats/chats_controller.dart';
import 'package:friend_zone/src/app/widgets/k_app_bar.dart';
import 'package:friend_zone/src/data/repositories/data_chat_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:friend_zone/src/domain/entities/message.dart';
import 'package:friend_zone/src/domain/entities/user.dart';

class ChatsViewHolder extends StatefulWidget {
  @override
  _ChatsViewHolderState createState() => _ChatsViewHolderState();
}

class _ChatsViewHolderState extends State<ChatsViewHolder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChatsView();
  }

  @override
  bool get wantKeepAlive => true;
}

class ChatsView extends View {
  @override
  State<StatefulWidget> createState() => _ChatsViewSate(
        ChatsController(
          DataUserRepository(),
          DataChatRepository(),
        ),
      );
}

class _ChatsViewSate extends ViewState<ChatsView, ChatsController> {
  _ChatsViewSate(ChatsController controller) : super(controller);

  @override
  Widget get view {
    EdgeInsets padding = MediaQuery.of(context).padding;

    return Scaffold(
        backgroundColor: kBackground,
        key: globalKey,
        body: ControlledWidgetBuilder<ChatsController>(
            builder: (context, controller) {
          return controller.lastMessages == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: kPrimary,
                  ),
                )
              : Column(
                  children: [
                    KAppBar(
                      header: 'Chats',
                      back: false,
                    ),
                    Expanded(
                      child: controller.lastMessages!.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 45),
                              child: Text(
                                'No message history. Lets start a conversation',
                                textAlign: TextAlign.center,
                                style: k14w400AxiBlackGeneralText(
                                    color: kBlack.withOpacity(0.4)),
                              ),
                            )
                          : ListView(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              physics: AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 20),
                              children: [
                                for (int i = 0;
                                    i < controller.lastMessages!.length;
                                    i++)
                                  _LastMessageContainer(
                                      controller.lastMessages![i])
                              ],
                            ),
                    ),
                  ],
                );
        }));
  }
}

class _LastMessageContainer extends StatelessWidget {
  final Message message;

  _LastMessageContainer(this.message);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    late User userToShow;

    final currentUserId = auth.FirebaseAuth.instance.currentUser!.uid;

    if (currentUserId == message.from.id) {
      userToShow = message.to;
    } else {
      userToShow = message.from;
    }

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          height: 90,
          width: size.width,
          color: kWhite,
          padding: EdgeInsets.symmetric(horizontal: 27),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 65,
                height: 65,
                child: Image.asset('assets/icons/png/default_user.png'),
                decoration: BoxDecoration(shape: BoxShape.circle),
              ),
              SizedBox(width: 20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userToShow.displayName.toString(),
                      style: k14w400AxiBlackGeneralText(color: kPrimary),
                    ),
                    Text(
                      message.text,
                      style: k10w300AxiBerryHomeShoppingHistoryContentText(
                          color: currentUserId == message.from.id
                              ? kSecondary
                              : kPrimary),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          height: 90,
          width: size.width,
          child: TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith(
                    (_) => kPrimary.withOpacity(0.2))),
            onPressed: () {
              KNavigator.navigateToChat(context: context, user: userToShow);
            },
            child: Container(),
          ),
        ),
      ],
    );
  }
}
