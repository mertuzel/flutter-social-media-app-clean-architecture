import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/pages/story/story_controller.dart';
import 'package:friend_zone/src/app/widgets/k_post.dart';
import 'package:friend_zone/src/data/repositories/data_story_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:friend_zone/src/data/utils/string_utils.dart';
import 'package:friend_zone/src/domain/entities/story.dart';
import 'package:friend_zone/src/domain/entities/story_item.dart';

import "package:story_view/story_view.dart" as sw;
import 'package:flutter_svg/svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StoryViewHolder extends StatefulWidget {
  final List<Story> stories;
  final int storyIndex;

  StoryViewHolder(this.stories, this.storyIndex);

  @override
  State<StoryViewHolder> createState() => _StoryViewHolderState();
}

class _StoryViewHolderState extends State<StoryViewHolder> {
  bool isPopped = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PageController pageController = PageController(
      initialPage: widget.storyIndex,
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return true;
      },
      child: PageView(
        children: [
          for (var i = 0; i < widget.stories.length; i++)
            StoryView(
              widget.stories[i],
              pageController,
              widget.stories[i] == widget.stories.last ? true : false,
            ),
          VisibilityDetector(
            key: ValueKey(ValueKey),
            onVisibilityChanged: (a) {
              if (a.visibleFraction > 0.2) if (!isPopped) {
                Navigator.pop(context);
                isPopped = true;
              }
            },
            child: Container(
              width: size.width,
              height: size.height,
              color: kBlack,
            ),
          ),
        ],
        controller: pageController,
      ),
    );
  }
}

class StoryView extends View {
  final Story story;
  final PageController pageController;
  final bool isLast;

  StoryView(this.story, this.pageController, this.isLast);

  @override
  State<StatefulWidget> createState() {
    return _StoryViewState(
      StoryController(
        DataStoryRepository(),
        DataUserRepository(),
        story,
      ),
      story,
    );
  }
}

class _StoryViewState extends ViewState<StoryView, StoryController> {
  _StoryViewState(StoryController controller, this.story)
      : storyItems = List.from(
          story.items.map(
            (StoryItem storyItem) => sw.StoryItem.pageImage(
              shown: storyItem.isSeen,
              url: storyItem.imageUrl,
              controller: controller.storyController,
              imageFit: BoxFit.fitWidth,
              duration: Duration(seconds: 5),
            ),
          ),
        ),
        super(controller);

  final Story story;
  List<sw.StoryItem> storyItems;
  int? currentIndex;

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;

    return ControlledWidgetBuilder<StoryController>(
      builder: (context, controller) {
        return Scaffold(
          key: globalKey,
          backgroundColor: Colors.black,
          body: NotificationListener<ScrollNotification>(
            onNotification: (a) {
              if (a.metrics.pixels < -100) {
                controller.closePage();
              }
              return false;
            },
            child: ListView(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                Container(
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    children: [
                      sw.StoryView(
                        controller: controller.storyController,
                        storyItems: storyItems,
                        inline: false,
                        onComplete: () => widget.isLast
                            ? controller.closePage()
                            : widget.pageController.nextPage(
                                duration: Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn),
                        onStoryShow: (sw.StoryItem storyItem) {
                          currentIndex = storyItems.indexOf(storyItem);
                          Future.delayed(Duration.zero)
                              .then((_) => controller.refreshScreen());
                          final currentStory =
                              controller.story.items[currentIndex!];

                          if (!currentStory.isSeen) {
                            controller.setStoryAsSeen(
                                controller.story.id, currentStory.id);
                          }
                        },
                      ),
                      Positioned(
                        left: 21,
                        top: padding.top + 22,
                        child: _StoryInfoContainer(
                          name: story.publisherName,
                          logoUrl: story.publisherLogoUrl,
                          sharedOn: currentIndex != null
                              ? StringUtils.getPublishDateShort(
                                  story.items[currentIndex!].sharedOn)
                              : '',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StoryInfoContainer extends StatelessWidget {
  final String name;
  final String logoUrl;
  final String sharedOn;

  const _StoryInfoContainer({
    required this.name,
    required this.logoUrl,
    required this.sharedOn,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith(
          (_) => EdgeInsets.zero,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: MaterialStateProperty.resolveWith(
          (_) => Colors.transparent,
        ),
        minimumSize: MaterialStateProperty.resolveWith(
          (_) => Size(0, 0),
        ),
      ),
      child: Container(
        width: size.width,
        padding: EdgeInsets.only(right: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: kWhite,
                  ),
                  height: 35,
                  width: 35,
                  padding: EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: logoUrl.isEmpty
                        ? Image.asset(
                            'assets/icons/png/default_user.png',
                          )
                        : CachedNetworkImage(
                            imageUrl: logoUrl,
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                            placeholder: (a, b) {
                              return ShimmheredPublisher();
                            },
                          ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: kWhite,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  sharedOn,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            ControlledWidgetBuilder<StoryController>(
                builder: (context, controller) {
              return InkWell(
                child: SvgPicture.asset(
                  'assets/icons/svg/close.svg',
                  color: kWhite,
                ),
                onTap: () => controller.closePage(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
