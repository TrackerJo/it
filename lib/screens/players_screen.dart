import 'package:flutter/material.dart';
import 'package:it/main.dart';
import 'package:it/widgets/fancy_container.dart';
import 'package:it/widgets/player_icon.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
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
                Text(
                  "players",
                  style: styling.headerFont.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: styling.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: styling.pink, width: 4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            PlayerIcon(
                              icon: "Ek",
                              color: styling.blue,
                              size: 60,
                              iconSize: 30,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Jake",
                                      style: styling.headerFont.copyWith(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: styling.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: styling.pink,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      width: 40,
                                      child: Center(
                                        child: Text(
                                          "IT",
                                          style: styling.bodyFont.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: styling.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "41m 23s of suffering",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: styling.orange,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "4",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: styling.orange,
                                  ),
                                ),
                                Text(
                                  "TAGS",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: styling.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FancyContainer(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            PlayerIcon(
                              icon: "Ek",
                              color: styling.blue,
                              size: 60,
                              iconSize: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Emily",
                              style: styling.headerFont.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: styling.blue,
                              ),
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "12",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: styling.orange,
                                  ),
                                ),
                                Text(
                                  "TAGS",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: styling.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
