import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:it/constants.dart';
import 'package:it/screens/gotcha_screen.dart';
import 'package:it/screens/home_screen.dart';
import 'package:it/screens/it_screen.dart';
import 'package:it/screens/onboarding_screen.dart';
import 'package:it/screens/tag_screen.dart';
import 'package:it/styling.dart';

void main() {
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
  ],
);

final Styling styling = Styling();

final Game game = createTestGame();
final Player player = game.getPlayerFromId("p1");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
