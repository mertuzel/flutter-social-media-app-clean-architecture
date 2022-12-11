import 'package:flutter/cupertino.dart';
import 'package:friend_zone/src/app/pages/add_post/add_post_view.dart';
import 'package:friend_zone/src/app/pages/add_story/add_story_view.dart';
import 'package:friend_zone/src/app/pages/authentication/decider/auth_decider_view.dart';
import 'package:friend_zone/src/app/pages/authentication/start/start_phone_authentication_view.dart';
import 'package:friend_zone/src/app/pages/authentication/verify/verify_phone_number_view.dart';
import 'package:friend_zone/src/app/pages/chat/chat_view.dart';
import 'package:friend_zone/src/app/pages/comments/comments_view.dart';
import 'package:friend_zone/src/app/pages/core/core_controller.dart';
import 'package:friend_zone/src/app/pages/core/core_view.dart';
import 'package:friend_zone/src/app/pages/splash/splash_view.dart';
import 'package:friend_zone/src/app/pages/username/username_view.dart';
import 'package:friend_zone/src/domain/entities/user.dart';
import 'package:page_transition/page_transition.dart';

class KNavigator {
  static const CURVE = Curves.fastLinearToSlowEaseIn;
  static const DURATION = Duration(milliseconds: 235);

  static void changeLoadingStatus(bool value) async {
    CoreViewHolderController().changeLoadingStatus(value);
  }

  static Future<void> navigateToPostAdd() async {
    await Navigator.push(
      CoreController().coreContext,
      CupertinoPageRoute(builder: (context) => AddPostView()),
    );
  }

  static Future<void> navigateToComments(
      BuildContext context, String postId) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => CommentsView(postId)),
    );
  }

  static Future<void> navigateToPhoneAuthenticationStart({
    required BuildContext context,
  }) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => PhoneAuthenticationStartView()),
    );
  }

  static Future<void> navigateToSplash(BuildContext context) async {
    CoreController().killInstance();
    CoreViewHolderController().killInstance();
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => SplashView()),
      (_) => false,
    );
  }

  static Future<void> navigateToPhoneAuthenticationVerify({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PhoneAuthenticationVerifyView(
          phoneNumber: phoneNumber,
        ),
      ),
    );
  }

  static Future<void> navigateToUsername(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => UsernameView()),
      (_) => false,
    );
  }

  static Future<void> navigateToAuthDecider(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => AuthDeciderView()),
      (_) => false,
    );
  }

  static Future<void> navigateToHome(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => CoreViewHolder()),
      (_) => false,
    );
  }

  static Future<void> navigateToAddStory() async {
    await Navigator.push(
      CoreController().coreContext,
      CupertinoPageRoute(builder: (context) => AddStoryView()),
    );
  }

  static Future<void> navigateToChat({
    required BuildContext context,
    required User user,
  }) async {
    await Navigator.push(
      CoreController().coreContext,
      CupertinoPageRoute(builder: (context) => ChatView(user)),
    );
  }
}
