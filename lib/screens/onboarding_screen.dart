import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/custom_tabs.dart';
import 'package:it/widgets/dotted_rounded_border.dart';
import 'package:it/widgets/fancy_container.dart';
import 'package:it/widgets/fancy_input_field.dart';
import 'package:it/widgets/player_icon.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedTab = "new";
  TextEditingController gameNameController = TextEditingController();
  TextEditingController newEmojiController = TextEditingController();
  TextEditingController newNameController = TextEditingController();

  TextEditingController joinEmojiController = TextEditingController();
  TextEditingController joinNameController = TextEditingController();
  TextEditingController joinCodeController = TextEditingController();

  static const _pressDuration = Duration(milliseconds: 80);
  bool buttonPressed = false;
  DateTime? _pressedAt;

  void _releaseButton() {
    if (!buttonPressed) return;
    final elapsed = DateTime.now().difference(_pressedAt ?? DateTime.now());
    final remaining = _pressDuration - elapsed;
    if (remaining > Duration.zero) {
      Future.delayed(remaining, () {
        if (mounted) setState(() => buttonPressed = false);
      });
    } else {
      setState(() => buttonPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    "tag is back.",
                    style: styling.headerFont.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: styling.blue,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  Text(
                    "this time, it's documented.",
                    style: styling.bodyFont.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: styling.blueMute,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTabs(
                    tabs: [
                      TabItem(label: "New Game", value: "new"),
                      TabItem(label: "Join", value: "join"),
                    ],
                    onTabChanged: (value) {
                      setState(() {
                        selectedTab = value;
                      });
                    },
                  ),
                  if (selectedTab == "new") ...buildNewGame(context),
                  if (selectedTab == "join") ...buildJoinGame(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildNewGame(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Text(
        "NAME YOUR GAME",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(controller: gameNameController),
      const SizedBox(height: 32),
      Text(
        "PICK AN EMOJI TO REPRESENT YOU IN THE GAME",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(controller: newEmojiController),
      const SizedBox(height: 32),
      Text(
        "WHAT SHOULD WE CALL YOU?",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(controller: newNameController),
      const SizedBox(height: 32),
      Text(
        "INVITE FRIENDS",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: DottedRoundedBorder(
                radius: 10,
                color: styling.blue,
                backgroundColor: styling.white,
                strokeWidth: 2,
                dashLength: 6,
                gapLength: 4,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "402342",
                    textAlign: TextAlign.center,
                    style: styling.numberFont.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: styling.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.copy, color: styling.blue),
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      GestureDetector(
        onTapDown: (details) {
          HapticFeedback.lightImpact();
          setState(() {
            buttonPressed = true;
            _pressedAt = DateTime.now();
          });
        },
        onTapUp: (details) {
          HapticFeedback.lightImpact();
          _releaseButton();
        },
        onTapCancel: _releaseButton,
        onTap: () {
          router.pushReplacement("/");
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, buttonPressed ? 5 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: styling.pink,
            shape: StadiumBorder(
              side: BorderSide(color: styling.blue, width: 2),
            ),
            shadows: [
              if (!buttonPressed)
                BoxShadow(
                  color: styling.blue,
                  offset: Offset(0, 5),
                  blurRadius: 0,
                ),
            ],
          ),
          child: Text(
            "Start the Chaos",
            style: styling.bodyFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: styling.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  List<Widget> buildJoinGame(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Text(
        "PICK AN EMOJI TO REPRESENT YOU IN THE GAME",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(controller: joinEmojiController),
      const SizedBox(height: 32),
      Text(
        "WHAT SHOULD WE CALL YOU?",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(controller: joinNameController),
      const SizedBox(height: 32),
      Text(
        "ENTER GAME CODE",
        style: styling.bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: styling.blue,
        ),
      ),
      const SizedBox(height: 8),
      FancyInputField(controller: joinCodeController),
      const SizedBox(height: 32),
      GestureDetector(
        onTapDown: (details) {
          HapticFeedback.lightImpact();
          setState(() {
            buttonPressed = true;
            _pressedAt = DateTime.now();
          });
        },
        onTapUp: (details) {
          HapticFeedback.lightImpact();
          _releaseButton();
        },
        onTapCancel: _releaseButton,
        onTap: () {
          router.pushReplacement("/");
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, buttonPressed ? 5 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: styling.pink,
            shape: StadiumBorder(
              side: BorderSide(color: styling.blue, width: 2),
            ),
            shadows: [
              if (!buttonPressed)
                BoxShadow(
                  color: styling.blue,
                  offset: Offset(0, 5),
                  blurRadius: 0,
                ),
            ],
          ),
          child: Text(
            "Join the Chaos",
            style: styling.bodyFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: styling.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }
}
