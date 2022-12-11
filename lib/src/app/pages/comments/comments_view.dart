import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/pages/comments/comments_controller.dart';
import 'package:friend_zone/src/app/widgets/k_app_bar.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';
import 'package:friend_zone/src/data/repositories/data_post_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:friend_zone/src/data/utils/string_utils.dart';
import 'package:friend_zone/src/domain/entities/comment.dart';
import 'package:friend_zone/src/domain/usecases/remove_comment.dart';

class CommentsView extends View {
  final String postId;

  CommentsView(this.postId);

  @override
  State<StatefulWidget> createState() => _CommentsViewState(
        CommentsController(
          DataPostRepository(),
          DataUserRepository(),
          postId,
        ),
      );
}

class _CommentsViewState extends ViewState<CommentsView, CommentsController> {
  _CommentsViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<CommentsController>(
          builder: (context, controller) {
        return Column(
          children: [
            KAppBar(
              header: 'Comments',
            ),
            Expanded(
              child: !controller.commentsInitializedFirstTime
                  ? Container()
                  : controller.comments.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: KButton(
                                mainText: 'Add',
                                onPressed: () {},
                                textStyle: k14w600ProxWhiteButtonText(
                                  color: kBackground,
                                ),
                                bgColor: Colors.transparent,
                              ),
                              margin: EdgeInsets.only(top: 35),
                            ),
                            Text(
                              'No comments to show',
                              style: k14w400AxiBlackGeneralText(
                                  color: kBlack.withOpacity(0.4)),
                            ),
                            Container(
                              child: KButton(
                                mainText: 'Add',
                                onPressed: controller.openAddComment,
                              ),
                              margin: EdgeInsets.only(bottom: 35),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.082,
                            vertical: size.width * 0.082,
                          ),
                          physics: kPhysics,
                          child: Column(
                            children: [
                              for (int i = 0;
                                  i < controller.comments.length;
                                  i++)
                                Column(
                                  children: [
                                    _Comment(
                                      comment: controller.comments[i],
                                      removeComment: controller.removeComment,
                                    ),
                                    if (i == controller.comments.length - 1 &&
                                        !controller.isAllCommentsFetched)
                                      kCircularProgressIndicator(
                                          color: kPrimary)
                                  ],
                                ),
                              Container(
                                margin: EdgeInsets.only(top: 35),
                                child: KButton(
                                  width: size.width * 0.836,
                                  mainText: 'Add',
                                  onPressed: controller.openAddComment,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        );
      }),
    );
  }
}

class _Comment extends StatelessWidget {
  final Comment comment;
  final Function(String commentId) removeComment;
  const _Comment({Key? key, required this.comment, required this.removeComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(
        bottom: size.height * 0.01458,
      ),
      child: Slidable(
        key: ValueKey(comment.id),
        endActionPane:
            comment.authorId != auth.FirebaseAuth.instance.currentUser!.uid
                ? null
                : ActionPane(
                    extentRatio: 0.35,
                    motion: ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {
                      removeComment(comment.id);
                    }),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          removeComment(comment.id);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: size.width * 0.112,
                  height: size.width * 0.112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(comment.authorId ==
                                auth.FirebaseAuth.instance.currentUser!.uid
                            ? 'assets/icons/png/current_user.png'
                            : 'assets/icons/png/default_user.png'),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(width: size.width * 0.028),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width -
                          ((size.width * 0.082) * 2 +
                              size.width * 0.112 +
                              size.width * 0.028),
                      child: Text(
                        comment.authorName,
                        style: k12w700MontsBlackBottomHeader(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: size.width -
                          ((size.width * 0.082) * 2 +
                              size.width * 0.112 +
                              size.width * 0.028),
                      child: Text(
                        StringUtils.getDateInDayMonthYearFormat(
                                comment.sharedOn, '/') +
                            ' ' +
                            StringUtils.getDateInMinSecFormat(comment.sharedOn),
                        style: k10w400AxiBlackBottomText(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.112 + size.width * 0.028),
              child: Text(
                comment.text,
                style: k10w400AxiBlackBottomText(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: size.height * 0.0108,
            ),
            Opacity(
              opacity: 0.2,
              child: Container(
                height: 1,
                color: kBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
