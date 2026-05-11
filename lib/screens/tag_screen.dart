import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/player_icon.dart';
import 'package:it/widgets/tag_sheet.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> with TickerProviderStateMixin {
  String? selectedPlayer;
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

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
            ValueListenableBuilder<Game>(
              valueListenable: gameNotifier,
              builder: (context, game, _) => SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ...() {
                      final available = game.players
                          .where((player) => !player.isIt)
                          .toList();
                    return available.asMap().entries.map((entry) {
                      final index = entry.key;
                      final player = entry.value;
                      final stagger = (index * 0.08).clamp(0.0, 0.5);
                      final popEnd = (stagger + 0.45).clamp(0.0, 1.0);
                      final giggleEnd = (stagger + 0.9).clamp(0.0, 1.0);
                      return AnimatedBuilder(
                        animation: _entranceController,
                        builder: (context, child) {
                          final popT = Interval(
                            stagger,
                            popEnd,
                            curve: Curves.elasticOut,
                          ).transform(_entranceController.value);
                          final giggleT = Interval(
                            stagger,
                            giggleEnd,
                            curve: Curves.easeOut,
                          ).transform(_entranceController.value);
                          final scale = popT.clamp(0.0, 1.2);
                          final wiggle =
                              sin(giggleT * pi * 3) * 0.18 * (1 - giggleT);
                          return Opacity(
                            opacity: popT.clamp(0.0, 1.0),
                            child: Transform.rotate(
                              angle: wiggle,
                              child: Transform.scale(
                                scale: scale,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            setState(() {
                              selectedPlayer = player.name;
                            });
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  TagSheet(taggedPlayer: player),
                            );
                            setState(() {
                              selectedPlayer = null;
                            });
                          },
                          child: Column(
                            children: [
                              PlayerIcon(
                                player: player,
                                size: selectedPlayer == player.name ? 110 : 100,
                                borderColor: selectedPlayer == player.name
                                    ? player.color
                                    : null,
                                borderWidth: selectedPlayer == player.name
                                    ? 4
                                    : 2,
                                iconSize: selectedPlayer == player.name
                                    ? 60
                                    : 50,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                player.name,
                                style: styling.bodyFont.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: styling.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  }(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
