import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/api/database.dart';
import 'package:it/api/notifications.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/dotted_rounded_border.dart';
import 'package:it/widgets/in_app_notification.dart';
import 'package:it/widgets/player_icon.dart';

class ItScreen extends StatefulWidget {
  const ItScreen({super.key});

  @override
  State<ItScreen> createState() => _ItScreenState();
}

class _ItScreenState extends State<ItScreen>
    with SingleTickerProviderStateMixin {
  static const _pressDuration = Duration(milliseconds: 80);
  bool buttonPressed = false;
  DateTime? _pressedAt;
  Player? taggedBy;
  Timer? _timer;
  String timerText = "";
  late final AnimationController _wiggleController;

  void _updateTimer() {
    final game = gameNotifier.value;
    if (!game!.isStarted) return;
    final elapsed = DateTime.now().difference(
      game.latestTag?.timestamp ?? game.startedAt!,
    );
    if (!mounted) return;
    setState(() {
      timerText = _formatElapsed(elapsed);
    });
  }

  String _formatElapsed(Duration d) {
    if (d.isNegative) d = Duration.zero;
    if (d.inDays >= 1) {
      return "${d.inDays}d ${d.inHours.remainder(24)}h";
    }
    if (d.inHours >= 1) {
      return "${d.inHours}h ${d.inMinutes.remainder(60)}m";
    }
    if (d.inMinutes >= 1) {
      return "${d.inMinutes}m ${d.inSeconds.remainder(60)}s";
    }
    return "${d.inSeconds}s";
  }

  void _onGameChanged() {
    final game = gameNotifier.value;
    if (!game!.isStarted) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    if (game.latestTag == null) {
      taggedBy = null;
    } else {
      taggedBy = game.getPlayerFromId(game.latestTag!.taggerPlayerId);
    }

    _timer ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateTimer(),
    );
    _updateTimer();
  }

  @override
  void initState() {
    super.initState();
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    gameNotifier.addListener(_onGameChanged);
    _onGameChanged();
  }

  @override
  void dispose() {
    gameNotifier.removeListener(_onGameChanged);
    _wiggleController.dispose();
    _timer?.cancel();
    super.dispose();
  }

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
    return ListenableBuilder(
      listenable: Listenable.merge([gameNotifier, playerNotifier]),
      builder: (context, _) {
        final game = gameNotifier.value;
        final player = playerNotifier.value;
        return !game!.isStarted
            ? _buildWaiting(context)
            : player!.isIt
            ? _buildIt(context)
            : _buildOtherIt(context);
      },
    );
  }

  Widget _buildWaiting(BuildContext context) {
    final player = playerNotifier.value;
    return Scaffold(
      backgroundColor: styling.green,

      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,

        child: Column(
          mainAxisAlignment: .center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 16),

            Spacer(),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Waiting for the game to start...",

                  style: styling.headerFont.copyWith(
                    fontSize: 60,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: styling.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Spacer(),
            if (player!.isHost && gameNotifier.value!.players.length >= 2) ...[
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
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
                            "Game Code: ${gameNotifier.value!.joinCode}",
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
                        Clipboard.setData(
                          ClipboardData(
                            text: gameNotifier.value!.joinCode.toString(),
                          ),
                        );
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
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
                    gameNotifier.value!.startGame();
                    gameNotifier.refresh();
                    Database().updateGame(gameNotifier.value!);
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 80),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(
                      0,
                      buttonPressed ? 5 : 0,
                      0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 16,
                    ),
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: styling.pink,
                      shape: StadiumBorder(),
                      shadows: [
                        if (!buttonPressed)
                          BoxShadow(
                            color: styling.darkPink,
                            offset: Offset(0, 5),
                            blurRadius: 0,
                          ),
                      ],
                    ),
                    child: Text(
                      "Start Game",
                      style: styling.bodyFont.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: styling.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ] else if (player.isHost) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Waiting for at least 1 more player to join.",
                  style: styling.bodyFont.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: styling.blueMute,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
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
                            "Game Code: ${gameNotifier.value!.joinCode}",
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
                        Clipboard.setData(
                          ClipboardData(
                            text: gameNotifier.value!.joinCode.toString(),
                          ),
                        );
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
            ],

            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherIt(BuildContext context) {
    final game = gameNotifier.value;
    return Scaffold(
      backgroundColor: styling.green,

      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,

        child: Column(
          mainAxisAlignment: .center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 16),

            Text(
              "-- CURRENTLY IT --",
              style: styling.bodyFont.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: styling.blueMute,
              ),
            ),
            Spacer(),
            AnimatedBuilder(
              animation: _wiggleController,
              builder: (context, child) {
                final t = _wiggleController.value * 2 * pi;
                final angle = sin(t) * 0.08;
                final dy = (cos(t * 2) - 1) * 2;
                return Transform.translate(
                  offset: Offset(0, dy),
                  child: Transform.rotate(angle: angle, child: child),
                );
              },
              child: PlayerIcon(
                player: game!.itPlayer!,
                size: 200,
                iconSize: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  game.itPlayer!.name,
                  maxLines: 1,
                  style: styling.headerFont.copyWith(
                    fontSize: 88,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: styling.blue,
                  ),
                ),
              ),
            ),
            if (taggedBy != null)
              RichText(
                text: TextSpan(
                  text: "tagged by ",
                  style: styling.bodyFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: styling.blueMute,
                  ),
                  children: [
                    TextSpan(
                      text: taggedBy?.name ?? "Unknown",
                      style: styling.bodyFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: styling.blue,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Text(
              "They've been it for",
              style: styling.bodyFont.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: styling.blueMute,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: StadiumBorder(
                  side: BorderSide(color: styling.blue, width: 4),
                ),
                shadows: [
                  BoxShadow(
                    color: styling.blue,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                timerText,
                style: styling.numberFont.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: styling.orange,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
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
                  // TauntNotification notification = TauntNotification(
                  //   id: 1,
                  //   targetIds: [playerNotifier.value!.name],
                  //   taunterName: playerNotifier.value!.name,
                  // );
                  // TagNotification notification = TagNotification(
                  //   id: 1,
                  //   targetIds: [game.itPlayer!.id],
                  //   taggedName: playerNotifier.value!.name,
                  //   taggerName: game.itPlayer!.name,
                  // );
                  TauntNotification notification = TauntNotification(
                    id: 1,
                    targetIds: [gameNotifier.value!.itPlayer!.fcmToken!],

                    taunterName: playerNotifier.value!.name,
                  );
                  PushNotifications().sendNotification(notif: notification);
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(
                    0,
                    buttonPressed ? 5 : 0,
                    0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: styling.pink,
                    shape: StadiumBorder(),
                    shadows: [
                      if (!buttonPressed)
                        BoxShadow(
                          color: styling.darkPink,
                          offset: Offset(0, 5),
                          blurRadius: 0,
                        ),
                    ],
                  ),
                  child: Text(
                    "Taunt ${game.itPlayer!.name}",
                    style: styling.bodyFont.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: styling.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildIt(BuildContext context) {
    return Scaffold(
      backgroundColor: styling.pink,

      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,

        child: Column(
          mainAxisAlignment: .center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Spacer(),

            AnimatedBuilder(
              animation: _wiggleController,
              builder: (context, child) {
                final t = _wiggleController.value * 2 * pi;
                final angle = sin(t) * 0.12;
                final dy = (cos(t * 2) - 1) * 2;
                return Transform.translate(
                  offset: Offset(0, dy),
                  child: Transform.rotate(angle: angle, child: child),
                );
              },
              child: const Text("🫵", style: TextStyle(fontSize: 100)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "You're",
                  maxLines: 1,
                  style: styling.headerFont.copyWith(
                    fontSize: 90,
                    fontWeight: FontWeight.w400,
                    color: styling.white,
                    height: 0.95,
                    shadows: [
                      Shadow(
                        color: styling.blue,
                        offset: Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "IT",
                style: styling.headerFont.copyWith(
                  fontSize: 90,
                  fontWeight: FontWeight.w400,
                  color: styling.white,
                  height: 0.95,
                  shadows: [
                    Shadow(
                      color: styling.blue,
                      offset: Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),

                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: BoxDecoration(
                color: styling.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                "${timerText} of shame",
                style: styling.numberFont.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: styling.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "${taggedBy != null ? "${taggedBy?.name ?? ""} tagged you. " : ""}Get rid of it before someone makes it weird.",
              style: styling.bodyFont.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: styling.white,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
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
                  router.push("/home/tag");
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(
                    0,
                    buttonPressed ? 5 : 0,
                    0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: styling.orange,
                    shape: StadiumBorder(
                      side: BorderSide(color: styling.blue, width: 4),
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
                    "I Tagged Someone →",
                    style: styling.bodyFont.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: styling.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}
