import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
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
    final elapsed = DateTime.now().difference(game.latestTag.timestamp);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taggedBy = game.getPlayerFromId(game.latestTag.taggerPlayerId);
    setState(() {});
    _updateTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTimer();
    });
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _wiggleController.dispose();
    super.dispose();
    _timer?.cancel();
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
    return player.isIt ? _buildIt(context) : _buildOtherIt(context);
  }

  Widget _buildOtherIt(BuildContext context) {
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
                player: game.itPlayer,
                size: 200,
                iconSize: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  game.itPlayer.name,
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
                    "Boo ${game.itPlayer.name}",
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
              child: Text(
                "YOU'RE IT",
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
              "${taggedBy?.name ?? ""} tagged you. Get rid of it before someone makes it weird.",
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
                  router.push("/welcome");
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
