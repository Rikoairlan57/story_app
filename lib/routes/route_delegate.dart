import 'package:flutter/material.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/ui/screen/create_story_screen.dart';
import 'package:story_app/ui/screen/detail_story_screen.dart';
import 'package:story_app/ui/screen/login_screen.dart';
import 'package:story_app/ui/screen/register_screen.dart';
import 'package:story_app/ui/screen/story_list_screen.dart';

class MyRouteDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;
  bool isForm = false;
  bool isCamera = false;

  MyRouteDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  String? selectedStory;
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool? isRegister = false;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegister = false;
        selectedStory = null;
        isCamera = false;
        isForm = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

      List<Page>  _loggedInStack => [
                MaterialPage(
            key: const ValueKey("StoryListScreen"),
            child: StoryListScreen(
              
            )),
                   if (selectedStory != null)
          MaterialPage(
            key: ValueKey(selectedStory),
            child: DetailStoryScreen(
             
            ),
          ),
        if (isForm)
          MaterialPage(
            key: const ValueKey("FormScreen"),
            child: CreateStoryScreen(
              
            ),
          ),
      ];
}
