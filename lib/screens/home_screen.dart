import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/screens/it_screen.dart';
import 'package:it/screens/me_screen.dart';
import 'package:it/screens/players_screen.dart';
import 'package:it/screens/records_screen.dart';
import 'package:it/widgets/nav_bar.dart';
import 'package:it/widgets/player_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Screens activeScreen = Screens.it;
  PageController pageController = PageController();
  bool changingFromNavBar = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Game?>(
      valueListenable: gameNotifier,
      builder: (context, game, _) {
        return Scaffold(
          backgroundColor: styling.green,
          body: Column(
            mainAxisAlignment: .center,
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    if (changingFromNavBar) {
                      return;
                    }
                    setState(() {
                      activeScreen = Screens.values[value];
                    });
                  },
                  children: [
                    ItScreen(),

                    PlayersScreen(),
                    if (game?.isStarted ?? false) RecordsScreen(),
                    MeScreen(),
                  ],
                ),
              ),
              NavBar(
                activeScreen: activeScreen,
                onTap: (screen) {
                  setState(() {
                    changingFromNavBar = true;
                  });
                  HapticFeedback.lightImpact();
                  setState(() {
                    activeScreen = screen;
                    pageController.animateToPage(
                      screen.index -
                          (game?.isStarted ?? false
                              ? 0
                              : screen == Screens.me
                              ? 1
                              : 0),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                  Future.delayed(Duration(milliseconds: 300), () {
                    setState(() {
                      changingFromNavBar = false;
                    });
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
