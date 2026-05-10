import 'dart:async';

import 'package:flutter/material.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/fancy_container.dart';
import 'package:it/widgets/player_icon.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  Player? playerNemesis;
  Player? playerFavoriteVictim;
  Duration? longestItStint;
  Duration? longestSafeStreak;
  Timer? _timer;
  String timerText = "";

  void _updateTimer() {
    final elapsed = DateTime.now().difference(
      game.getLastPlayerTag(player.id).timestamp,
    );
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playerNemesis = game.getPlayerNemesis(player.id);
    playerFavoriteVictim = game.getPlayerFavoriteVictim(player.id);
    longestItStint = game.getPlayerLongestItDuration(player.id);
    longestSafeStreak = game.getPlayerLongestSafeDuration(player.id);
    setState(() {});
    _updateTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTimer();
    });
  }

  String formatDuration(Duration d, {bool compact = false}) {
    if (d.isNegative) d = Duration.zero;
    if (d.inDays >= 1) {
      return "${d.inDays}d${compact ? "" : " ${d.inHours.remainder(24)}h"}";
    }
    if (d.inHours >= 1) {
      return "${d.inHours}h${compact ? "" : " ${d.inMinutes.remainder(60)}m"}";
    }
    if (d.inMinutes >= 1) {
      return "${d.inMinutes}m${compact ? "" : " ${d.inSeconds.remainder(60)}s"}";
    }
    return "${d.inSeconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: styling.green,

      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,

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
                        width: 50,
                        height: 50,
                        offset: 3,
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
                  drawCircle: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            PlayerIcon(player: player, size: 80, iconSize: 40),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.name,
                                  style: styling.headerFont.copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w400,
                                    color: styling.blue,
                                  ),
                                ),
                                Text(
                                  game.name,
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
                          backgroundColor: player.isIt
                              ? styling.lightPink
                              : styling.lightGreen,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.isIt ? "IT FOR" : "SAFE FOR",
                                  style: styling.bodyFont.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: styling.blue,
                                  ),
                                ),
                                Text(
                                  timerText,
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
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16,
                          children: [
                            Expanded(
                              child: FancyContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "PEOPLE TAGGED",
                                        style: styling.bodyFont.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: styling.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        game
                                            .getPlayerTagCount(player.id)
                                            .toString(),
                                        style: styling.headerFont.copyWith(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w400,
                                          color: styling.pink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: FancyContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "TIMES TAGGED",
                                        style: styling.bodyFont.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: styling.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        game
                                            .getPlayerTaggedCount(player.id)
                                            .toString(),
                                        style: styling.headerFont.copyWith(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w400,
                                          color: styling.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16,
                          children: [
                            if (longestItStint != null)
                              Expanded(
                                child: FancyContainer(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "LONGEST STINT AS IT",
                                          style: styling.bodyFont.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: styling.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          formatDuration(longestItStint!),

                                          style: styling.headerFont.copyWith(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400,
                                            color: styling.blueText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (longestSafeStreak != null)
                              Expanded(
                                child: FancyContainer(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "SAFE STREAK",
                                          style: styling.bodyFont.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: styling.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          formatDuration(longestSafeStreak!),
                                          style: styling.headerFont.copyWith(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400,
                                            color: styling.greenText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16,
                          children: [
                            if (playerNemesis != null)
                              Expanded(
                                child: FancyContainer(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16.0,
                                      16,
                                      10,
                                      16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "NEMESIS",
                                          style: styling.bodyFont.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: styling.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            PlayerIcon(
                                              player: playerNemesis!,
                                              size: 32,
                                              iconSize: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  playerNemesis!.name,
                                                  style: styling.headerFont
                                                      .copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: styling.blue,
                                                      ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  "tagged you 4 times",
                                                  style: styling.bodyFont
                                                      .copyWith(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: styling.orange,
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
                              ),
                            if (playerFavoriteVictim != null)
                              Expanded(
                                child: FancyContainer(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16.0,
                                      16,
                                      0,
                                      16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "FAVORITE VICTIM",
                                          style: styling.bodyFont.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: styling.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            PlayerIcon(
                                              player: playerFavoriteVictim!,
                                              size: 32,
                                              iconSize: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  playerFavoriteVictim!.name,
                                                  style: styling.headerFont
                                                      .copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: styling.blue,
                                                      ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.of(
                                                            context,
                                                          ).size.width /
                                                          2 -
                                                      24 -
                                                      16 -
                                                      32 -
                                                      4 -
                                                      20,
                                                  child: Text(
                                                    "you tagged them 3 times",
                                                    style: styling.bodyFont
                                                        .copyWith(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: styling.orange,
                                                        ),
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
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
