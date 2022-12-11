import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/pages/chat/chat_controller.dart';
import 'package:friend_zone/src/app/widgets/message_container.dart';
import 'package:friend_zone/src/data/repositories/data_chat_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:friend_zone/src/domain/entities/user.dart';

class ChatView extends View {
  final User peerUser;

  ChatView(this.peerUser);

  @override
  State<StatefulWidget> createState() => _ChatViewState(
        ChatController(
          DataUserRepository(),
          DataChatRepository(),
          peerUser,
        ),
      );
}

class _ChatViewState extends ViewState<ChatView, ChatController> {
  _ChatViewState(ChatController controller) : super(controller);

  @override
  Widget get view {
    bool isKeyboardClosed = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<ChatController>(
          builder: (context, controller) {
        Size size = MediaQuery.of(context).size;
        EdgeInsets padding = MediaQuery.of(context).padding;

        return controller.messages == null
            ? Center(
                child: CircularProgressIndicator(
                color: kPrimary,
              ))
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: padding.top + 50),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith(
                                    (_) => kPrimary.withOpacity(0.2)),
                                padding: MaterialStateProperty.resolveWith(
                                  (_) => EdgeInsets.zero,
                                ),
                                minimumSize: MaterialStateProperty.resolveWith(
                                  (_) => Size(0, 0),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: kPrimary,
                                size: 27,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 65,
                              height: 65,
                              child: Image.asset(
                                'assets/icons/png/default_user.png',
                              ),
                              decoration: BoxDecoration(shape: BoxShape.circle),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: size.width - 198,
                              child: Text(
                                widget.peerUser.displayName,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    k14w400AxiBlackGeneralText(color: kPrimary),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: size.width,
                        height: 1,
                        color: Colors.black12,
                      ),
                      Expanded(
                        child: controller.messages!.isEmpty
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
                                controller: controller.scrollController,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.manual,
                                physics: AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 29),
                                children: [
                                  for (int i = 0;
                                      i < controller.messages!.length;
                                      i++)
                                    MessageContainer(controller.messages![i]),
                                  if (!isKeyboardClosed) SizedBox(height: 200),
                                ],
                              ),
                      ),
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            color: kBlack.withOpacity(0.03),
                            offset: Offset(0, 2),
                          )
                        ]),
                        margin: EdgeInsets.only(
                          left: 40,
                          right: 50,
                          bottom: padding.bottom + 10,
                        ),
                        child: TextFormField(
                          controller: controller.textEditingController,
                          onChanged: (text) {
                            controller.onMessageWrite(text.trim());
                          },
                          minLines: 1,
                          maxLines: 3,
                          style: k14w400AxiBlackGeneralText(
                              color: kBlack.withOpacity(0.8)),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: controller.userMessage.length < 2
                                  ? null
                                  : controller.sendMessage,
                              splashColor: Colors.transparent,
                              color: kPrimary,
                            ),
                            isDense: true,
                            fillColor: kWhite,
                            filled: true,
                            hintStyle:
                                k13w300AxiWhiteProfileHeaderText(color: kDot),
                            hintText: 'Write your message',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
