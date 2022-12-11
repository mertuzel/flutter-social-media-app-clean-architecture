import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/pages/chats/chats_view.dart';
import 'package:friend_zone/src/app/pages/core/core_presenter.dart';
import 'package:friend_zone/src/app/pages/favorites/favorites_view.dart';
import 'package:friend_zone/src/app/pages/home/home_view.dart';
import 'package:friend_zone/src/app/pages/users/users_view.dart';

class CoreController extends Controller {
  final CorePresenter _presenter;

  static CoreController? _instance;

  CoreController._() : _presenter = CorePresenter();

  factory CoreController() {
    // ignore: prefer_conditional_assignment
    if (_instance == null) {
      _instance = CoreController._();
    }
    return _instance!;
  }

  /// This controller is singleton to ease navigations.
  /// Use wisely.
  BuildContext get coreContext => getContext();

  PageController pageController = PageController();
  int selectedIndex = 0;

  final homePageKey = GlobalKey<NavigatorState>();
  final favoritesPageKey = GlobalKey<NavigatorState>();
  final chatsPageKey = GlobalKey<NavigatorState>();
  final usersPageKey = GlobalKey<NavigatorState>();

  late List<Widget> pages;
  List<Map<String, dynamic>> navigationItems = [
    {'text': DefaultTexts.home, 'iconPath': 'nav-home.svg'},
    {'text': DefaultTexts.favs, 'iconPath': 'star.svg'},
    {'text': '', 'iconPath': ''},
    {'text': DefaultTexts.chats, 'iconPath': 'chat.svg'},
    {'text': DefaultTexts.users, 'iconPath': 'nav-profile.svg'},
  ];

  void killInstance() {
    _instance = null;
  }

  @override
  void onInitState() {
    selectedIndex = 0;
    pages = [
      Navigator(
        key: homePageKey,
        pages: [MaterialPage(child: HomeViewHolder())],
        onPopPage: (route, result) => route.didPop(result),
      ),
      Navigator(
        key: favoritesPageKey,
        pages: [MaterialPage(child: FavoritesViewHolder())],
        onPopPage: (route, result) => route.didPop(result),
      ),
      Container(),
      Navigator(
        key: chatsPageKey,
        pages: [MaterialPage(child: ChatsViewHolder())],
        onPopPage: (route, result) => route.didPop(result),
      ),
      Navigator(
        key: usersPageKey,
        pages: [MaterialPage(child: UsersViewHolder())],
        onPopPage: (route, result) => route.didPop(result),
      ),
    ];
    super.onInitState();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }

  Future<bool> handleOnWillPop() async {
    bool homePop = false;
    bool favoritesPop = false;
    bool chatsPop = false;
    bool usersPop = false;
    try {
      if (selectedIndex == 0) {
        homePop = await homePageKey.currentState!.maybePop();
      }
    } catch (e) {}
    try {
      if (selectedIndex == 1) {
        favoritesPop = await favoritesPageKey.currentState!.maybePop();
      }
    } catch (e) {}
    try {
      if (selectedIndex == 3) {
        chatsPop = await chatsPageKey.currentState!.maybePop();
      }
    } catch (e) {}
    try {
      if (selectedIndex == 4) {
        usersPop = await usersPageKey.currentState!.maybePop();
      }
    } catch (e) {}

    if (homePop || favoritesPop || chatsPop || usersPop) return true;

    return false;
  }

  void onNavigationItemTap(int index) async {
    if (index == 0 && selectedIndex == 0) {
      try {
        bool maybePop = await homePageKey.currentState!.maybePop();
        // if (!maybePop) scrollToTapForHome();
      } catch (e) {}
      return;
    }

    if (index == 1 && selectedIndex == 1) {
      try {
        bool maybePop = await favoritesPageKey.currentState!.maybePop();
      } catch (e) {}
      return;
    }

    if (index == 3 && selectedIndex == 3) {
      try {
        bool maybePop = await chatsPageKey.currentState!.maybePop();
      } catch (e) {}
      return;
    }

    if (index == 4 && selectedIndex == 4) {
      try {
        bool maybePop = await usersPageKey.currentState!.maybePop();
      } catch (e) {}
      return;
    } else {
      selectedIndex = index;
      pageController.jumpToPage(index);
      refreshUI();
    }
  }
}
