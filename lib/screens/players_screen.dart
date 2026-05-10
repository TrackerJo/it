import 'dart:async';

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
  Timer? _timer;
  String timerText = "";

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

    _updateTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTimer();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

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
                  height: 106,
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
                              player: game.itPlayer,
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
                                      game.itPlayer.name,
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
                                  "${timerText} of suffering",
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
                                  game
                                      .getPlayerTagCount(game.itPlayer.id)
                                      .toString(),
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
                ...game.players.where((player) => !player.isIt).map((player) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FancyContainer(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            PlayerIcon(player: player, size: 60, iconSize: 30),
                            const SizedBox(width: 8),
                            Text(
                              player.name,
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
                                  game.getPlayerTagCount(player.id).toString(),
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
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
