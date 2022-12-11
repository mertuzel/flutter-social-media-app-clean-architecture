import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/users/users_controller.dart';
import 'package:friend_zone/src/app/widgets/k_app_bar.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:friend_zone/src/domain/entities/user.dart';

class UsersViewHolder extends StatefulWidget {
  @override
  _UsersViewHolderState createState() => _UsersViewHolderState();
}

class _UsersViewHolderState extends State<UsersViewHolder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return UsersView();
  }

  @override
  bool get wantKeepAlive => true;
}

class UsersView extends View {
  @override
  State<StatefulWidget> createState() => _UsersViewState(
        UsersController(
          DataUserRepository(),
        ),
      );
}

class _UsersViewState extends ViewState<UsersView, UsersController> {
  _UsersViewState(UsersController controller) : super(controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: kBackground,
      key: globalKey,
      body: ControlledWidgetBuilder<UsersController>(
          builder: (context, controller) {
        return Column(
          children: [
            KAppBar(
              header: 'Users',
              back: false,
            ),
            Expanded(
              child: controller.users == null
                  ? Center(
                      child: kCircularProgressIndicator(color: kPrimary),
                    )
                  : controller.users!.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 45),
                          child: Text(
                            'No users signed for the app',
                            textAlign: TextAlign.center,
                            style: k14w400AxiBlackGeneralText(
                                color: kBlack.withOpacity(0.4)),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: kPhysics,
                          child: Column(
                            children: [
                              SizedBox(height: 60),
                              if (controller.users!.isNotEmpty &&
                                  controller.users!.length != 1)
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 35),
                                  child: Text(
                                      controller.users!.length == 1
                                          ? (controller.users!.length)
                                                  .toString() +
                                              ' user'
                                          : (controller.users!.length)
                                                  .toString() +
                                              ' users',
                                      style: k14w400AxiBlackGeneralText(
                                          color: kPrimary)),
                                ),
                              SizedBox(height: 20),
                              for (int i = 0; i < controller.users!.length; i++)
                                _UserContainer(controller.users![i]),
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

class _UserContainer extends StatelessWidget {
  final User user;

  _UserContainer(this.user);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final currentUserId = auth.FirebaseAuth.instance.currentUser!.uid;

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
            children: [
              Container(
                width: 65,
                height: 65,
                child: Image.asset(user.id == currentUserId
                    ? 'assets/icons/png/current_user.png'
                    : 'assets/icons/png/default_user.png'),
                decoration: BoxDecoration(shape: BoxShape.circle),
              ),
              SizedBox(width: 20),
              Flexible(
                child: Text(
                  user.id == currentUserId
                      ? user.displayName.toString() + ' (You)'
                      : user.displayName.toString(),
                  style: k16w400AxiBlackText(color: kPrimary),
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
                overlayColor: MaterialStateProperty.resolveWith((_) =>
                    user.id == currentUserId
                        ? Colors.transparent
                        : kPrimary.withOpacity(0.2))),
            onPressed: user.id == currentUserId
                ? null
                : () {
                    KNavigator.navigateToChat(context: context, user: user);
                  },
            child: Container(),
          ),
        ),
      ],
    );
  }
}
