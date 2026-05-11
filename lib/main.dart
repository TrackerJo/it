import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it/api/auth.dart';
import 'package:it/api/database.dart';
import 'package:it/api/shared_prefs.dart';

import 'package:it/constants.dart';
import 'package:it/firebase_options.dart';
import 'package:it/screens/gotcha_screen.dart';
import 'package:it/screens/home_screen.dart';

import 'package:it/screens/login_screen.dart';
import 'package:it/screens/onboarding_screen.dart';
import 'package:it/screens/tag_screen.dart';
import 'package:it/screens/welcome_sreen.dart';
import 'package:it/styling.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'it',
  );
  runApp(const MyApp());
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [GoRoute(path: 'tag', builder: (context, state) => TagScreen())],
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/gotcha',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: const Duration(milliseconds: 200),
        child: const GotchaScreen(),
        transitionsBuilder: (context, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(path: '/welcome', builder: (context, state) => WelcomeSreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  ],
);

final Styling styling = Styling();

class GameNotifier extends ValueNotifier<Game> {
  GameNotifier(super.value);
  void refresh() => notifyListeners();
}

final GameNotifier gameNotifier = GameNotifier(createTestGame());
final ValueNotifier<Player> playerNotifier = ValueNotifier<Player>(
  gameNotifier.value.getPlayerFromId("p1"),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> init() async {
    String? gameId = await SharedPrefs.getGameIdSF();

    Auth().authStateChanges().listen((user) async {
      if (user == null) {
        router.push("/welcome");
      } else if (gameId == null) {
        router.pushReplacement("/onboarding");
      } else {
        Game fetchedGame = await Database().getGame(gameId);
        gameNotifier.value = fetchedGame;
        playerNotifier.value = fetchedGame.getPlayerFromId(
          Auth().getUserId()!,
        );
        print(
          "Fetched game with id ${fetchedGame.id} and ${fetchedGame.players.length} players and hasStarted: ${fetchedGame.isStarted}",
        );
        Database().gameDataStream();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'It!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      routerConfig: router,
    );
  }
}
