import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/screens/it_screen.dart';
import 'package:it/widgets/nav_bar.dart';
import 'package:it/widgets/player_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Screens activeScreen = Screens.it;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Expanded(
            child: PageView(
              children: [
                ItScreen(),
                Container(color: Colors.blue),
                Container(color: Colors.green),
              ],
            ),
          ),
          NavBar(
            activeScreen: activeScreen,
            onTap: (screen) {
              HapticFeedback.lightImpact();
              setState(() {
                activeScreen = screen;
              });
            },
          ),
        ],
      ),
    );
  }
}
