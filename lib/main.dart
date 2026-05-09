import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  ],
);

final Styling styling = Styling();

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
