import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/favorites/favorites_controller.dart';
import 'package:friend_zone/src/app/widgets/k_app_bar.dart';
import 'package:friend_zone/src/app/widgets/k_post.dart';
import 'package:friend_zone/src/data/repositories/data_post_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';

class FavoritesViewHolder extends StatefulWidget {
  const FavoritesViewHolder({Key? key}) : super(key: key);

  @override
  State<FavoritesViewHolder> createState() => _FavoritesViewHolderState();
}

class _FavoritesViewHolderState extends State<FavoritesViewHolder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _FavoritesView();
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: use_key_in_widget_constructors
class _FavoritesView extends View {
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _FavoritesViewState(
        FavoritesController(
          DataPostRepository(),
          DataUserRepository(),
        ),
      );
}

class _FavoritesViewState
    extends ViewState<_FavoritesView, FavoritesController> {
  _FavoritesViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      body: Column(
        children: [
          ControlledWidgetBuilder<FavoritesController>(
              builder: (context, controller) {
            return GestureDetector(
              onTap: () {
                controller.scrollController.animateTo(
                  0,
                  duration: KNavigator.DURATION,
                  curve: KNavigator.CURVE,
                );
              },
              child: KAppBar(
                header: 'Favorites',
                back: false,
              ),
            );
          }),
          ControlledWidgetBuilder<FavoritesController>(
              builder: (context, controller) {
            return Expanded(
              child: controller.posts == null
                  ? Container()
                  : controller.posts!.isEmpty
                      ? Center(
                          child: Text(
                          'No favorite to show',
                          style: k14w400AxiBlackGeneralText(
                              color: kBlack.withOpacity(0.4)),
                        ))
                      : SingleChildScrollView(
                          controller: controller.scrollController,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          physics: kPhysics,
                          child: Column(
                            children: [
                              for (int i = 0; i < controller.posts!.length; i++)
                                KPost(
                                  index: i,
                                  post: controller.posts![i],
                                  changePostLike: controller.changePostLike,
                                  navigateToComments: (a, b) {
                                    KNavigator.navigateToComments(
                                      context,
                                      controller.posts![i].id,
                                    );
                                  },
                                  toggleFavoriteState:
                                      controller.removeFromFavorite,
                                  showAnimation: controller.lastLikedPost ==
                                      controller.posts![i].id,
                                )
                            ],
                          ),
                        ),
            );
          }),
        ],
      ),
    );
  }
}
