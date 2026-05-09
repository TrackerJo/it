import 'package:flutter/material.dart';
import 'package:it/main.dart';
import 'package:it/widgets/fancy_container.dart';
import 'package:it/widgets/player_icon.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "me",
                        style: styling.headerFont.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: styling.blue,
                        ),
                      ),
                      FancyContainer(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.settings,
                            color: styling.blue,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FancyContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            PlayerIcon(
                              icon: "Ek",
                              color: styling.blue,
                              size: 80,
                              iconSize: 40,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nathaniel",
                                  style: styling.headerFont.copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w400,
                                    color: styling.blue,
                                  ),
                                ),
                                Text(
                                  "Sophmore Kid's",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: styling.blueMute,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FancyContainer(
                          width: double.infinity,
                          backgroundColor: styling.lightGreen,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SAFE FOR",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: styling.blue,
                                  ),
                                ),
                                Text(
                                  "1h 23m",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: styling.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
