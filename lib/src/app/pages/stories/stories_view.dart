import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/stories/stories_controller.dart';
import 'package:friend_zone/src/app/widgets/story_container.dart';
import 'package:friend_zone/src/data/repositories/data_story_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:shimmer/shimmer.dart';

class StoriesViewHolder extends StatefulWidget {
  final Stream<bool?> refresh;
  const StoriesViewHolder({Key? key, required this.refresh}) : super(key: key);

  @override
  State<StoriesViewHolder> createState() => _StoriesViewHolderState();
}

class _StoriesViewHolderState extends State<StoriesViewHolder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoriesView(widget.refresh);
  }

  @override
  bool get wantKeepAlive => true;
}

class StoriesView extends View {
  final Stream<bool?> refresh;

  StoriesView(this.refresh);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _StoryViewState(
      StoriesController(
        DataStoryRepository(),
        DataUserRepository(),
        refresh,
      ),
    );
  }
}

class _StoryViewState extends ViewState<StoriesView, StoriesController> {
  _StoryViewState(StoriesController controller) : super(controller);

  @override
  Widget get view {
    return ControlledWidgetBuilder<StoriesController>(
      builder: (context, controller) {
        Size size = MediaQuery.of(context).size;
        return controller.stories == null
            ? Container(
                width: size.width,
                height: 120,
                padding: EdgeInsets.only(left: 18),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 6; i++) _ShimmeredStory(),
                    ],
                  ),
                ),
              )
            : Scaffold(
                key: globalKey,
                body: Container(
                  width: size.width,
                  height: 120,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    // controller: controller.storiesScrollController,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: hitTestBehavior,
                                onTap: KNavigator.navigateToAddStory,
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kWhite,
                                    border: Border.all(
                                      color: kSecondary,
                                      width: 3,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(17.0),
                                    child: Image.asset(
                                      'assets/icons/png/plus.png',
                                      color: kSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 23),
                            ],
                          ),
                          SizedBox(width: 5),
                          for (int i = 0; i < controller.stories!.length; i++)
                            StoryContainer(
                                controller.stories![i],
                                controller.stories!,
                                controller.isStoryLoading,
                                controller.changeLoadingStatus),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _ShimmeredStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        margin: EdgeInsets.only(right: 10),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: kGrey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: 30,
              height: 10,
              decoration: BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
      gradient: kLinearGradient,
    );
  }
}
