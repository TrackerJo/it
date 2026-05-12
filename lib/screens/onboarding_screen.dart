import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/api/auth.dart';
import 'package:it/api/database.dart';
import 'package:it/api/shared_prefs.dart';
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

  String gameCode = "402342";

  Color iconColor = styling.blue;
  List<Color> iconColors = [
    styling.blue,
    styling.pink,
    styling.orange,
    styling.green,
  ];

  static const _pressDuration = Duration(milliseconds: 80);
  bool buttonPressed = false;
  DateTime? _pressedAt;
  bool isLoading = false;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    gameCode = DateTime.now().millisecondsSinceEpoch.toString().substring(
      time.length - 6,
      time.length,
    );
    setState(() {});
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

            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
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
        "PICK A COLOR FOR YOUR ICON",
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
            SizedBox(
              height: 40,
              width: iconColors.length * 52 - 12,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: iconColors.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  Color color = iconColors[index];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        iconColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: iconColor == color
                              ? styling.white
                              : styling.black,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            PlayerIcon(
              player: MiniPlayer(
                name: "You",
                icon: newEmojiController.text,
                color: iconColor,
              ),
              size: 75,
              iconSize: 75 / 2,
            ),
            Spacer(),
          ],
        ),
      ),
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
                    gameCode,
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
              onPressed: () {
                Clipboard.setData(ClipboardData(text: gameCode));
                SnackBar snackBar = SnackBar(
                  content: Text("Game code copied to clipboard!"),
                  backgroundColor: styling.blue,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
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
        onTap: () async {
          if (isLoading) return;
          if (gameNameController.text.isEmpty ||
              newEmojiController.text.isEmpty ||
              newNameController.text.isEmpty) {
            SnackBar snackBar = SnackBar(
              content: Text("Please fill out all fields!"),
              backgroundColor: styling.blue,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          //Validate one emoji put in emoji controller
          if (newEmojiController.text.runes.length != 1) {
            SnackBar snackBar = SnackBar(
              content: Text("Please enter a single emoji!"),
              backgroundColor: styling.blue,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          final emojiRegex = RegExp(
            r'[\u{1F300}-\u{1F5FF}]|' // Misc Symbols and Pictographs
            r'[\u{1F600}-\u{1F64F}]|' // Emoticons
            r'[\u{1F680}-\u{1F6FF}]|' // Transport and Map
            r'[\u{1F700}-\u{1F77F}]|' // Alchemical Symbols
            r'[\u{1F780}-\u{1F7FF}]|' // Geometric Shapes Extended
            r'[\u{1F800}-\u{1F8FF}]|' // Supplemental Arrows-C
            r'[\u{1F900}-\u{1F9FF}]|' // Supplemental Symbols and Pictographs
            r'[\u{1FA00}-\u{1FA6F}]|' // Chess Symbols, Symbols and Pictographs Extended-A
            r'[\u{1FA70}-\u{1FAFF}]|' // Symbols and Pictographs Extended-A
            r'[\u{2600}-\u{26FF}]|' // Misc symbols
            r'[\u{2700}-\u{27BF}]', // Dingbats
            unicode: true,
          );
          if (!emojiRegex.hasMatch(newEmojiController.text)) {
            SnackBar snackBar = SnackBar(
              content: Text("Please enter a valid emoji!"),
              backgroundColor: styling.blue,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          setState(() {
            isLoading = true;
          });
          Player newPlayer = Player(
            name: newNameController.text,
            icon: newEmojiController.text,
            color: iconColor,
            id: Auth().getUserId()!,
            isHost: true,
          );

          Game newGame = Game(
            name: gameNameController.text,
            joinCode: int.parse(gameCode),
            players: [newPlayer],
            id: "",
            tags: [],
            createdAt: DateTime.now(),
          );

          newGame = await Database().createGame(newGame);
          await SharedPrefs.setGameIdSF(newGame.id);
          gameNotifier.value = newGame;
          playerNotifier.value = newGame.getPlayerFromId(Auth().getUserId()!);
          Database().gameDataStream();

          print("Game created with ID: ${newGame.id}");

          router.pushReplacement("/home");
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
        "PICK A COLOR FOR YOUR ICON",
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
            SizedBox(
              height: 40,
              width: iconColors.length * 52 - 12,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: iconColors.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  Color color = iconColors[index];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        iconColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: iconColor == color
                              ? styling.white
                              : styling.black,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            PlayerIcon(
              player: MiniPlayer(
                name: "You",
                icon: joinEmojiController.text,
                color: iconColor,
              ),
              size: 75,
              iconSize: 75 / 2,
            ),
            Spacer(),
          ],
        ),
      ),
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
        onTap: () async {
          if (joinCodeController.text.isEmpty ||
              joinEmojiController.text.isEmpty ||
              joinNameController.text.isEmpty) {
            SnackBar snackBar = SnackBar(
              content: Text("Please fill out all fields!"),
              backgroundColor: styling.blue,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          //Validate one emoji put in emoji controller
          if (joinEmojiController.text.runes.length != 1) {
            SnackBar snackBar = SnackBar(
              content: Text("Please enter a single emoji!"),
              backgroundColor: styling.blue,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          final emojiRegex = RegExp(
            r'[\u{1F300}-\u{1F5FF}]|' // Misc Symbols and Pictographs
            r'[\u{1F600}-\u{1F64F}]|' // Emoticons
            r'[\u{1F680}-\u{1F6FF}]|' // Transport and Map
            r'[\u{1F700}-\u{1F77F}]|' // Alchemical Symbols
            r'[\u{1F780}-\u{1F7FF}]|' // Geometric Shapes Extended
            r'[\u{1F800}-\u{1F8FF}]|' // Supplemental Arrows-C
            r'[\u{1F900}-\u{1F9FF}]|' // Supplemental Symbols and Pictographs
            r'[\u{1FA00}-\u{1FA6F}]|' // Chess Symbols, Symbols and Pictographs Extended-A
            r'[\u{1FA70}-\u{1FAFF}]|' // Symbols and Pictographs Extended-A
            r'[\u{2600}-\u{26FF}]|' // Misc symbols
            r'[\u{2700}-\u{27BF}]', // Dingbats
            unicode: true,
          );
          if (!emojiRegex.hasMatch(joinEmojiController.text)) {
            SnackBar snackBar = SnackBar(
              content: Text("Please enter a valid emoji!"),
              backgroundColor: styling.blue,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          Game? joinedGame = await Database().joinGame(
            joinCodeController.text,
            Player(
              name: joinNameController.text,
              icon: joinEmojiController.text,
              color: iconColor,
              id: Auth().getUserId()!,
            ),
          );

          if (joinedGame == null) {
            SnackBar snackBar = SnackBar(
              content: Text("Game not found! Please check your game code."),
              backgroundColor: styling.blue,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          await SharedPrefs.setGameIdSF(joinedGame.id);
          gameNotifier.value = joinedGame;
          playerNotifier.value = joinedGame.getPlayerFromId(
            Auth().getUserId()!,
          );
          Database().gameDataStream();
          print("Joined game with ID: ${joinedGame.id}");
          router.pushReplacement("/home");
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
