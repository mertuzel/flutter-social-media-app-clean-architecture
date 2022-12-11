import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/pages/story/story_view.dart';
import 'package:friend_zone/src/domain/entities/story.dart';
import 'package:shimmer/shimmer.dart';

class StoryContainer extends StatefulWidget {
  final Story story;
  final List<Story> stories;
  final bool isStoryLoading;
  final void Function(bool value) changeLoadingStatus;

  StoryContainer(
      this.story, this.stories, this.isStoryLoading, this.changeLoadingStatus);

  @override
  _StoryContainerState createState() => _StoryContainerState();
}

class _StoryContainerState extends State<StoryContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> base;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OpenContainer(
            transitionDuration: Duration(milliseconds: 199),
            useRootNavigator: true,
            openBuilder: (context, action) {
              return StoryViewHolder(
                  widget.stories, widget.stories.indexOf(widget.story));
            },
            closedElevation: 0,
            openElevation: 0,
            closedShape: CircleBorder(),
            onClosed: (_) {
              setState(() {
                widget.changeLoadingStatus(false);
              });
            },
            closedBuilder: (context, action) {
              return Container(
                height: 70,
                width: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        width: 68,
                        height: 68,
                        padding: EdgeInsets.all(4),
                        child: widget.story.publisherLogoUrl.isEmpty
                            ? Image.asset(
                                widget.story.id ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? 'assets/icons/png/current_user.png'
                                    : 'assets/icons/png/default_user.png',
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.story.publisherLogoUrl,
                                fit: BoxFit.scaleDown,
                                placeholder: (a, b) {
                                  return ShimmeredStory();
                                },
                              )),
                    RotationTransition(
                      turns: base,
                      child: DottedBorder(
                        padding: EdgeInsets.zero,
                        strokeWidth: 2,
                        dashPattern: animationController.isAnimating
                            ? [1, 5, 2, 4, 3, 3, 4, 2, 5, 1, 6, 1, 112, 100]
                            : [1, 0],
                        borderType: BorderType.Circle,
                        color: widget.story.isAllSeen
                            ? Colors.grey.withOpacity(0.5)
                            : kPrimary,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          width: 65,
                          height: 65,
                        ),
                      ),
                    ),
                    Container(
                      width: 65,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!widget.isStoryLoading) {
                            widget.changeLoadingStatus(true);
                            setState(() {
                              animationController
                                  .forward(from: 0)
                                  .then((_) => setState(() {}));
                            });

                            widget.changeLoadingStatus(false);
                            action();
                          }
                        },
                        child: null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: CircleBorder(),
                          onPrimary: kPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 5),
          Text(
            widget.story.publisherName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: kBlack,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    base = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    super.initState();
  }
}

class ShimmeredStory extends StatelessWidget {
  const ShimmeredStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Shimmer(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: kGrey,
            shape: BoxShape.circle,
            border: Border.all(color: kBlack.withOpacity(0.04)),
          ),
        ),
        gradient: kLinearGradient);
  }
}
