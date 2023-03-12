import 'package:flutter/material.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/data/service/auth_service.dart';
import 'package:story_app/ui/screens/story_create_screen.dart';
import 'package:story_app/ui/screens/story_detail_screen.dart';
import 'package:story_app/ui/screens/home_screen.dart';
import 'package:story_app/ui/screens/login_screen.dart';
import 'package:story_app/ui/screens/register_screen.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Story App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: GoRouter(
        initialLocation: "/login",
        redirect: (context, GoRouterState state) async {
          if (state.location == "/login" || state.location == "/register") {
            final auth = AuthService(
              locale: AuthRepository(
                prefs: SharedPreferences.getInstance(),
              ),
            );
            if (await auth.isUserLogin()) {
              return "/home";
            } else {
              return null;
            }
          }
          return null;
        },
        routes: [
          GoRoute(
            path: "/login",
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: "/register",
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: "/home",
            builder: (context, state) => const HomeScreen(),
            redirect: (context, state) async {
              final auth = AuthService(
                locale: AuthRepository(
                  prefs: SharedPreferences.getInstance(),
                ),
              );
              if (await auth.isUserLogin() == false) {
                return "/login";
              } else {
                return null;
              }
            },
          ),
          GoRoute(
            path: '/detail/:storyId',
            builder: (context, state) => StoryDetailScreen(
              restaurantId: state.params['storyId']!,
            ),
          ),
          GoRoute(
            path: '/add',
            builder: (context, state) => const CreateStoryScreen(),
          ),
        ],
      ),
    );
  }
}
