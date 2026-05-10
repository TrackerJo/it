import 'package:flutter/material.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';
import 'package:it/widgets/fancy_container.dart';
import 'package:it/widgets/player_icon.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  Player? mostTagged;
  Player? untouchable;
  Map<Player, Duration> longestItStints = {};
  TagBack? fastestTagBack;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      mostTagged = game.getMostTaggedPlayer();
      untouchable = game.getUntouchablePlayer();
      longestItStints = game.getLongestItStints();
      fastestTagBack = game.getFastestTagBack();
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
            padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 16),
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
                if (mostTagged != null)
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
                                player: mostTagged!,
                                size: 60,
                                iconSize: 30,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                mostTagged!.name,
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
                                    game
                                        .getPlayerTagCount(mostTagged!.id)
                                        .toString(),
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
                if (mostTagged != null) const SizedBox(height: 32),
                if (untouchable != null)
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
                                player: untouchable!,
                                size: 60,
                                iconSize: 30,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                untouchable!.name,
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
                                    game
                                        .getPlayerTagCount(untouchable!.id)
                                        .toString(),
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
                if (untouchable != null) const SizedBox(height: 32),
                if (longestItStints.isNotEmpty)
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
                              ...longestItStints.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      //index the player for this entry in longestItStints to get their rank and display it before their name
                                      SizedBox(
                                        width: 24,
                                        child: Text(
                                          "${longestItStints.keys.toList().indexOf(entry.key) + 1}",
                                          style: styling.bodyFont.copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: styling.blue,
                                          ),
                                        ),
                                      ),

                                      PlayerIcon(
                                        player: entry.key,
                                        size: 50,
                                        iconSize: 25,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        entry.key.name,
                                        style: styling.bodyFont.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: styling.blue,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        formatDuration(entry.value),
                                        style: styling.numberFont.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: styling.pink,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (longestItStints.isNotEmpty) const SizedBox(height: 32),
                if (fastestTagBack != null)
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
                              Text(
                                "${game.getPlayerFromId(fastestTagBack!.taggerPlayerId).name} → ${game.getPlayerFromId(fastestTagBack!.taggedPlayerId).name}",
                                style: styling.bodyFont.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: styling.blueText,
                                ),
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatDuration(
                                      fastestTagBack!.length,
                                      compact: true,
                                    ),
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
