import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it/api/auth.dart';

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

final Game game = createTestGame();
final Player player = game.getPlayerFromId("p1");

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> init() async {
    bool loggedIn = Auth().isUserLoggedIn();
    if (!loggedIn) {
      router.push("/welcome");
    }
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
