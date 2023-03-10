import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/create_story_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/page_manager.dart';
import 'package:story_app/routes/route_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouteDelegate myRouteDelegate;
  late AuthProvider authProvider;
  final authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();

    authProvider = AuthProvider(authRepository, ApiService());

    myRouteDelegate = MyRouteDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => authProvider,
        ),
        ChangeNotifierProvider(create: (context) => PageManager()),
        ChangeNotifierProvider(
            create: (context) => StoryListProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (context) => CreateStoryProvider(ApiService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Story App',
        home: Router(
          routerDelegate: myRouteDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
