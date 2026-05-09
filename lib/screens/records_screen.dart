import 'package:flutter/material.dart';
import 'package:it/main.dart';
import 'package:it/widgets/fancy_container.dart';
import 'package:it/widgets/player_icon.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
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
                  "the records.",
                  style: styling.headerFont.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: styling.blue,
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
                        Text(
                          "Most Tagged",
                          style: styling.bodyFont.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: styling.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: styling.orange,
                                  ),
                                ),
                                Text(
                                  " L'S",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 16,
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
                const SizedBox(height: 32),
                FancyContainer(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Untouchable",
                          style: styling.bodyFont.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: styling.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            PlayerIcon(
                              icon: "Ek",
                              color: styling.green,
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
                                  "0",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
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
                const SizedBox(height: 32),
                FancyContainer(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Longest Stint as ",
                            style: styling.bodyFont.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: styling.blue,
                            ),
                            children: [
                              TextSpan(
                                text: "It",
                                style: styling.bodyFont.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: styling.pink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "1",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: styling.blue,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                PlayerIcon(
                                  icon: "Ek",
                                  color: styling.green,
                                  size: 40,
                                  iconSize: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Emily",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: styling.blue,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "40m",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: styling.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  "2",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: styling.blue,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                PlayerIcon(
                                  icon: "JS",
                                  color: styling.pink,
                                  size: 40,
                                  iconSize: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Jack",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: styling.blue,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "20m",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: styling.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  "3",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: styling.blue,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                PlayerIcon(
                                  icon: "SK",
                                  color: styling.orange,
                                  size: 40,
                                  iconSize: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Sarah",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: styling.blue,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "10m",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
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
                const SizedBox(height: 32),
                FancyContainer(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fastest Tag-Back",
                          style: styling.bodyFont.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: styling.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            PlayerIcon(
                              icon: "Ek",
                              color: styling.green,
                              size: 50,
                              iconSize: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Emily → Jack",
                              style: styling.bodyFont.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: styling.blue,
                              ),
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "15s",
                                  style: styling.numberFont.copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: styling.pink,
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
