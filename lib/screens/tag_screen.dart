import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/main.dart';
import 'package:it/widgets/player_icon.dart';
import 'package:it/widgets/tag_sheet.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  String? selectedPlayer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: styling.green,

      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: GestureDetector(
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
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                "who did\nyou tag?",
                style: styling.headerFont.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: styling.blue,
                  height: 1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                "Select the player you tagged to notify everyone else.",
                style: styling.bodyFont.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: styling.blueMute,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  GestureDetector(
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      setState(() {
                        selectedPlayer = "Sarah";
                      });
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) => TagSheet(),
                      );
                      setState(() {
                        selectedPlayer = null;
                      });
                    },
                    child: Column(
                      children: [
                        PlayerIcon(
                          icon: "SK",
                          color: styling.pink,
                          size: selectedPlayer == "Sarah" ? 110 : 100,
                          borderColor: selectedPlayer == "Sarah"
                              ? styling.pink
                              : null,
                          borderWidth: selectedPlayer == "Sarah" ? 4 : 2,
                          iconSize: selectedPlayer == "Sarah" ? 60 : 50,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sarah",
                          style: styling.bodyFont.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: styling.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      setState(() {
                        selectedPlayer = "Nathaniel";
                      });
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) => TagSheet(),
                      );
                      setState(() {
                        selectedPlayer = null;
                      });
                    },
                    child: Column(
                      children: [
                        PlayerIcon(
                          icon: "NK",
                          color: styling.orange,
                          size: selectedPlayer == "Nathaniel" ? 110 : 100,
                          borderColor: selectedPlayer == "Nathaniel"
                              ? styling.pink
                              : null,
                          borderWidth: selectedPlayer == "Nathaniel" ? 4 : 2,

                          iconSize: selectedPlayer == "Nathaniel" ? 60 : 50,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Nathaniel",
                          style: styling.bodyFont.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: styling.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      setState(() {
                        selectedPlayer = "Emily";
                      });
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) => TagSheet(),
                      );
                      setState(() {
                        selectedPlayer = null;
                      });
                    },
                    child: Column(
                      children: [
                        PlayerIcon(
                          icon: "EK",
                          color: styling.darkGreen,
                          size: selectedPlayer == "Emily" ? 110 : 100,
                          borderColor: selectedPlayer == "Emily"
                              ? styling.pink
                              : null,
                          borderWidth: selectedPlayer == "Emily" ? 4 : 2,
                          iconSize: selectedPlayer == "Emily" ? 60 : 50,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Emily",
                          style: styling.bodyFont.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: styling.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
