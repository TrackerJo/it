import 'package:flutter/material.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/nav_bar_icon.dart';
import 'package:it/widgets/player_icon.dart';

class NavBar extends StatelessWidget {
  final Screens activeScreen;
  final Function(Screens) onTap;
  const NavBar({
    super.key,
    this.activeScreen = Screens.it,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).padding.bottom + 50,

      decoration: BoxDecoration(
        color: Colors.white,
        border: BoxBorder.fromLTRB(
          top: BorderSide(color: styling.blue, width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarIcon(
            icon: Icons.back_hand_outlined,
            label: "Who's It?",
            isActive: activeScreen == Screens.it,
            onTap: () => onTap(Screens.it),
          ),
          NavBarIcon(
            icon: Icons.groups_outlined,
            label: "Players",
            isActive: activeScreen == Screens.players,
            onTap: () => onTap(Screens.players),
          ),

          NavBarIcon(
            icon: Icons.bar_chart_outlined,
            label: "Records",
            onTap: () => onTap(Screens.records),
            isActive: activeScreen == Screens.records,
          ),
          NavBarIcon(
            icon: Icons.person_outline,
            label: "Me",
            isActive: activeScreen == Screens.me,
            onTap: () => onTap(Screens.me),
          ),
        ],
      ),
    );
  }
}
