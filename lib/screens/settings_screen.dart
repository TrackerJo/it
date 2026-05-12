import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/api/auth.dart';
import 'package:it/api/shared_prefs.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/fancy_button.dart';
import 'package:it/widgets/fancy_container.dart';
import 'package:it/widgets/player_icon.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: styling.green,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,

          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),

                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    router.pop();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: styling.blue, size: 18),
                      Text(
                        "back",
                        style: styling.bodyFont.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,

                          color: styling.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "settings",
                  style: styling.headerFont.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: styling.blue,
                  ),
                ),
                const SizedBox(height: 16),
                FancyButton(
                  offset: Offset(0, 6),
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    await SharedPrefs.setGameIdSF(null);
                    await Auth().signOut();
                    router.pop();
                    router.pushReplacement("/welcome");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          "log out",
                          style: styling.bodyFont.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: styling.blue,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.logout, color: styling.blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FancyButton(
                  offset: Offset(0, 6),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          "delete account",
                          style: styling.bodyFont.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: styling.blue,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.delete, color: styling.blue),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
