import 'package:flutter/material.dart';

enum Screens { it, players, records, me }

class TabItem {
  final String value;
  final String label;

  final IconData? icon;
  final bool isSelected;

  const TabItem({
    required this.value,
    required this.label,

    this.icon,
    this.isSelected = false,
  });
}

class Player {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final bool isHost;
  int taunts;
  int timesTaunted;
  bool isIt;

  Player({
    required this.name,
    required this.icon,
    required this.color,
    this.isHost = false,
    this.isIt = false,
    this.taunts = 0,
    this.timesTaunted = 0,
    required this.id,
  });
}

class Tag {
  final String taggerPlayerId;
  final String taggedPlayerId;
  final DateTime timestamp;

  Tag({
    required this.taggerPlayerId,
    required this.taggedPlayerId,
    required this.timestamp,
  });
}

class TagBack {
  final String taggerPlayerId;
  final String taggedPlayerId;
  final Duration length;

  TagBack({
    required this.taggerPlayerId,
    required this.taggedPlayerId,
    required this.length,
  });
}

class Game {
  final String id;
  final String name;
  final List<Player> players;
  final List<Tag> tags;
  final DateTime createdAt;
  final int joinCode;

  Game({
    required this.id,
    required this.players,
    required this.tags,
    required this.createdAt,
    required this.joinCode,
    required this.name,
  });

  Player getPlayerFromId(String playerId) {
    return players.firstWhere((player) => player.id == playerId);
  }

  int getPlayerTagCount(String playerId) {
    return tags.where((tag) => tag.taggerPlayerId == playerId).length;
  }

  int getPlayerTaggedCount(String playerId) {
    return tags.where((tag) => tag.taggedPlayerId == playerId).length;
  }

  Player? getPlayerNemesis(String playerId) {
    Map<String, int> playerTags = {};
    for (var tag in tags) {
      if (tag.taggedPlayerId == playerId) {
        if (playerTags.containsKey(tag.taggerPlayerId)) {
          playerTags[tag.taggerPlayerId] = playerTags[tag.taggerPlayerId]! + 1;
        } else {
          playerTags[tag.taggerPlayerId] = 1;
        }
      }
    }

    String nemesisId = "";
    int mostTags = -1;

    for (var id in playerTags.keys) {
      if (playerTags[id]! > mostTags) {
        nemesisId = id;
        mostTags = playerTags[id]!;
      }
    }

    if (mostTags != -1) {
      return getPlayerFromId(nemesisId);
    }
    return null;
  }

  Player? getPlayerFavoriteVictim(String playerId) {
    Map<String, int> playerTags = {};
    for (var tag in tags) {
      if (tag.taggerPlayerId == playerId) {
        if (playerTags.containsKey(tag.taggedPlayerId)) {
          playerTags[tag.taggedPlayerId] = playerTags[tag.taggedPlayerId]! + 1;
        } else {
          playerTags[tag.taggedPlayerId] = 1;
        }
      }
    }

    String victimId = "";
    int mostTags = -1;

    for (var id in playerTags.keys) {
      if (playerTags[id]! > mostTags) {
        victimId = id;
        mostTags = playerTags[id]!;
      }
    }

    if (mostTags != -1) {
      return getPlayerFromId(victimId);
    }
    return null;
  }

  Player get itPlayer {
    return players.firstWhere((player) => player.isIt);
  }

  Tag get latestTag {
    return tags.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
  }

  Player? getMostTaggedPlayer() {
    Map<String, int> playerTags = {};
    for (var tag in tags) {
      if (playerTags.containsKey(tag.taggedPlayerId)) {
        playerTags[tag.taggedPlayerId] = playerTags[tag.taggedPlayerId]! + 1;
      } else {
        playerTags[tag.taggedPlayerId] = 1;
      }
    }

    String mostTaggedId = "";
    int mostTags = -1;

    for (var id in playerTags.keys) {
      if (playerTags[id]! > mostTags) {
        mostTaggedId = id;
        mostTags = playerTags[id]!;
      }
    }

    if (mostTags != -1) {
      return getPlayerFromId(mostTaggedId);
    }
    return null;
  }

  Player? getUntouchablePlayer() {
    Map<String, int> playerTags = {};
    for (var tag in tags) {
      if (playerTags.containsKey(tag.taggedPlayerId)) {
        playerTags[tag.taggedPlayerId] = playerTags[tag.taggedPlayerId]! + 1;
      } else {
        playerTags[tag.taggedPlayerId] = 1;
      }
    }

    String untouchableId = "";
    int leastTags = 999999;

    for (var id in playerTags.keys) {
      if (playerTags[id]! < leastTags) {
        untouchableId = id;
        leastTags = playerTags[id]!;
      }
    }

    if (leastTags != 999999) {
      return getPlayerFromId(untouchableId);
    }
    return null;
  }

  Map<Player, Duration> getLongestItStints() {
    Map<String, DateTime> itStartTimes = {};
    Map<String, Duration> itDurations = {};

    for (var tag in tags) {
      if (itStartTimes.containsKey(tag.taggerPlayerId)) {
        final duration = tag.timestamp.difference(
          itStartTimes[tag.taggerPlayerId]!,
        );
        if (itDurations.containsKey(tag.taggerPlayerId)) {
          itDurations[tag.taggerPlayerId] =
              itDurations[tag.taggerPlayerId]! + duration;
        } else {
          itDurations[tag.taggerPlayerId] = duration;
        }
      } else {
        final duration = tag.timestamp.difference(createdAt);
        itDurations[tag.taggerPlayerId] = duration;
      }
      itStartTimes[tag.taggedPlayerId] = tag.timestamp;
    }

    Map<Player, Duration> longestStints = {};
    for (var playerId in itDurations.keys) {
      longestStints[getPlayerFromId(playerId)] = itDurations[playerId]!;
    }

    longestStints = Map.fromEntries(
      longestStints.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    //top 3
    longestStints = Map.fromEntries(longestStints.entries.take(3));

    return longestStints;
  }

  Duration getPlayerLongestItDuration(String playerId) {
    final sorted = [...tags]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final Map<String, DateTime> itStartTimes = {};
    Duration longestDuration = Duration.zero;

    for (final tag in sorted) {
      if (tag.taggerPlayerId == playerId) {
        final start = itStartTimes[playerId] ?? createdAt;
        final dur = tag.timestamp.difference(start);
        if (dur > longestDuration) longestDuration = dur;
        itStartTimes.remove(playerId);
      }
      itStartTimes[tag.taggedPlayerId] = tag.timestamp;
    }

    final ongoingStart = itStartTimes[playerId];
    if (ongoingStart != null) {
      final dur = DateTime.now().difference(ongoingStart);
      if (dur > longestDuration) longestDuration = dur;
    }

    return longestDuration;
  }

  Duration getPlayerLongestSafeDuration(String playerId) {
    final sorted = [...tags]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final Map<String, DateTime> taggedAt = {};
    Duration longestDuration = Duration.zero;

    for (final tag in sorted) {
      if (tag.taggedPlayerId == playerId) {
        final start = taggedAt[playerId] ?? createdAt;
        final dur = tag.timestamp.difference(start);
        if (dur > longestDuration) longestDuration = dur;
        taggedAt.remove(playerId);
      }
      taggedAt[tag.taggedPlayerId] = tag.timestamp;
    }

    final ongoingStart = taggedAt[playerId];
    if (ongoingStart != null) {
      final dur = DateTime.now().difference(ongoingStart);
      if (dur > longestDuration) longestDuration = dur;
    }

    return longestDuration;
  }

  Tag getLastPlayerTag(String playerId) {
    final sorted = [...tags]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.firstWhere(
      (tag) => tag.taggedPlayerId == playerId || tag.taggerPlayerId == playerId,
    );
  }

  TagBack? getFastestTagBack() {
    final sorted = [...tags]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final Map<String, DateTime> taggedAt = {};
    TagBack? fastest;

    for (final tag in sorted) {
      final start = taggedAt[tag.taggerPlayerId];
      if (start != null) {
        final dur = tag.timestamp.difference(start);
        if (fastest == null || dur < fastest.length) {
          fastest = TagBack(
            taggerPlayerId: tag.taggerPlayerId,
            taggedPlayerId: tag.taggedPlayerId,
            length: dur,
          );
        }
        taggedAt.remove(tag.taggerPlayerId);
      }
      taggedAt[tag.taggedPlayerId] = tag.timestamp;
    }

    return fastest;
  }

  void tagPlayer(String taggedId) {
    String taggerId = itPlayer.id;
    final tag = Tag(
      taggerPlayerId: taggerId,
      taggedPlayerId: taggedId,
      timestamp: DateTime.now(),
    );
    tags.add(tag);
    getPlayerFromId(taggerId).isIt = false;
    getPlayerFromId(taggedId).isIt = true;
  }
}

Game createTestGame() {
  final players = [
    Player(
      id: "p1",
      name: "Nathaniel",
      icon: "Na",
      color: const Color(0xFF1d3557),
      isHost: true,
      isIt: true,
    ),
    Player(id: "p2", name: "Emily", icon: "Em", color: const Color(0xFFf46197)),
    Player(id: "p3", name: "Jack", icon: "Jk", color: const Color(0xFFff8811)),
    Player(id: "p4", name: "Sam", icon: "Sa", color: const Color(0xFF457b9d)),
    Player(id: "p5", name: "Mia", icon: "Mi", color: const Color(0xFF9eecbe)),
  ];

  final start = DateTime.now().subtract(const Duration(days: 3));
  DateTime at(int hours) => start.add(Duration(hours: hours));

  final tags = [
    Tag(taggerPlayerId: "p2", taggedPlayerId: "p1", timestamp: at(2)),
    Tag(taggerPlayerId: "p1", taggedPlayerId: "p3", timestamp: at(4)),
    Tag(taggerPlayerId: "p3", taggedPlayerId: "p5", timestamp: at(7)),
    Tag(taggerPlayerId: "p5", taggedPlayerId: "p1", timestamp: at(10)),
    Tag(taggerPlayerId: "p1", taggedPlayerId: "p3", timestamp: at(15)),
    Tag(taggerPlayerId: "p3", taggedPlayerId: "p4", timestamp: at(20)),
    Tag(taggerPlayerId: "p4", taggedPlayerId: "p1", timestamp: at(26)),
    Tag(taggerPlayerId: "p1", taggedPlayerId: "p2", timestamp: at(31)),

    Tag(
      taggerPlayerId: "p2",
      taggedPlayerId: "p1",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  for (final tag in tags) {
    final tagger = players.firstWhere((p) => p.id == tag.taggerPlayerId);
    final tagged = players.firstWhere((p) => p.id == tag.taggedPlayerId);
    tagger.taunts += 1;
    tagged.timesTaunted += 1;
  }

  return Game(
    id: "test-game",
    players: players,
    tags: tags,
    createdAt: start,
    joinCode: 1234,
    name: "Sophmores are Kid's?",
  );
}
