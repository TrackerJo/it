import 'package:flutter/material.dart';
import 'package:it/api/database.dart';
import 'package:it/main.dart';
import 'package:it/widgets/in_app_notification.dart';

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

class MiniPlayer {
  final String name;
  final String icon;
  final Color color;

  MiniPlayer({required this.name, required this.icon, required this.color});
}

class Player extends MiniPlayer {
  final String id;
  String? fcmToken;
  final bool isHost;
  int taunts;
  int timesTaunted;
  bool isIt;

  Player({
    required super.name,
    required super.icon,
    required super.color,
    this.fcmToken,
    this.isHost = false,
    this.isIt = false,
    this.taunts = 0,
    this.timesTaunted = 0,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.toARGB32(),
      'isHost': isHost,
      'taunts': taunts,
      'timesTaunted': timesTaunted,
      'isIt': isIt,
      'fcmToken': fcmToken,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      color: Color(map['color']),
      isHost: map['isHost'],
      taunts: map['taunts'],
      timesTaunted: map['timesTaunted'],
      isIt: map['isIt'],
      fcmToken: map['fcmToken'] ?? "",
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'taggerPlayerId': taggerPlayerId,
      'taggedPlayerId': taggedPlayerId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      taggerPlayerId: map['taggerPlayerId'],
      taggedPlayerId: map['taggedPlayerId'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
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
  String id;
  final String name;
  final List<Player> players;
  final List<Tag> tags;
  final DateTime createdAt;
  DateTime? startedAt;
  final int joinCode;
  bool isStarted;

  Game({
    required this.id,
    required this.players,
    required this.tags,
    required this.createdAt,
    this.startedAt,
    this.isStarted = false,
    required this.joinCode,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'players': players.map((p) => p.toMap()).toList(),
      'playerIds': players.map((p) => p.id).toList(),
      'tags': tags.map((t) => t.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'isStarted': isStarted,
      'joinCode': joinCode,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      name: map['name'],
      players: List<Player>.from(map['players']?.map((p) => Player.fromMap(p))),
      tags: List<Tag>.from(map['tags']?.map((t) => Tag.fromMap(t))),
      createdAt: DateTime.parse(map['createdAt']),
      startedAt: map['startedAt'] != null
          ? DateTime.parse(map['startedAt'])
          : null,
      isStarted: map['isStarted'],
      joinCode: map['joinCode'],
    );
  }

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

  Player? get itPlayer {
    return players.where((player) => player.isIt).firstOrNull;
  }

  Tag? get latestTag {
    if (tags.isEmpty) return null;
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

    for (var player in players) {
      playerTags[player.id] = 0;
    }
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
        final duration = tag.timestamp.difference(startedAt!);
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
        final start = itStartTimes[playerId] ?? startedAt;
        final dur = tag.timestamp.difference(start!);
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

    final bool startedAsIt =
        sorted.isNotEmpty && sorted.first.taggerPlayerId == playerId;
    DateTime? safeStart = startedAsIt ? null : startedAt;
    Duration longestDuration = Duration.zero;

    for (final tag in sorted) {
      if (tag.taggedPlayerId == playerId) {
        if (safeStart != null) {
          final dur = tag.timestamp.difference(safeStart);
          if (dur > longestDuration) longestDuration = dur;
          safeStart = null;
        }
      } else if (tag.taggerPlayerId == playerId) {
        safeStart = tag.timestamp;
      }
    }

    if (safeStart != null) {
      final dur = DateTime.now().difference(safeStart);
      if (dur > longestDuration) longestDuration = dur;
    }

    return longestDuration;
  }

  Tag? getLastPlayerTag(String playerId) {
    final sorted = [...tags]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted
        .where(
          (tag) =>
              tag.taggedPlayerId == playerId || tag.taggerPlayerId == playerId,
        )
        .firstOrNull;
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

  int getPlayerTagByPlayerCount(String taggerId, String taggedId) {
    return tags
        .where(
          (tag) =>
              tag.taggerPlayerId == taggerId && tag.taggedPlayerId == taggedId,
        )
        .length;
  }

  void tagPlayer(String taggedId) {
    String taggerId = itPlayer!.id;
    final tag = Tag(
      taggerPlayerId: taggerId,
      taggedPlayerId: taggedId,
      timestamp: DateTime.now(),
    );
    tags.add(tag);
    getPlayerFromId(taggerId).isIt = false;
    getPlayerFromId(taggedId).isIt = true;
    Database().updateGameTags(this);
  }

  void startGame() {
    if (isStarted) return;
    startedAt = DateTime.now();
    isStarted = true;
    int itPlayerIndex =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) % players.length;
    players[itPlayerIndex].isIt = true;
    Database().startGame(this);
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
    startedAt: start,
    joinCode: 1234,
    name: "Sophmores are Kid's?",
  );
}

enum NotificationType {
  taunt,
  tag,
  gameStart;

  @override
  String toString() {
    return name;
  }

  static NotificationType fromString(String type) {
    return NotificationType.values.firstWhere((e) => e.toString() == type);
  }
}

abstract class Notif {
  final int id;
  final NotificationType type;
  final String? title;
  final String? body;
  final List<String> targetIds;

  Notif({
    required this.id,
    required this.type,
    this.title,
    this.body,
    required this.targetIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),

      'title': title,
      'body': body,

      'targetIds': targetIds,
      'thread': type.toString(),
    };
  }

  factory Notif.fromMap(Map<String, dynamic> map) {
    NotificationType type = NotificationType.fromString(map['type']);
    switch (type) {
      case NotificationType.taunt:
        return TauntNotification.fromMap(map);
      case NotificationType.tag:
        return TagNotification.fromMap(map);
      case NotificationType.gameStart:
        return GameStartNotification.fromMap(map);
    }
  }

  InAppNotification toInAppNotification() {
    return InAppNotification(title: title ?? "", body: body ?? "");
  }
}

class TauntNotification extends Notif {
  final String taunterName;

  factory TauntNotification({
    required int id,
    required List<String> targetIds,
    required String taunterName,
  }) {
    final taunt = _generateTaunt(taunterName);
    return TauntNotification.withMessage(
      id: id,
      targetIds: targetIds,
      taunterName: taunterName,
      title: taunt['title']!,
      body: taunt['message']!,
    );
  }

  TauntNotification.withMessage({
    required super.id,
    required super.targetIds,
    required this.taunterName,
    required String super.title,
    required String super.body,
  }) : super(type: NotificationType.taunt);

  static Map<String, String> _generateTaunt(String taunterName) {
    final List<Map<String, String>> tagTauntNotifications = [
      {
        "title": "You’re It 😈",
        "message":
            "The campus is big… but somehow everyone is still dodging you.",
      },
      {
        "title": "Tag Them Already",
        "message":
            "$taunterName has been waiting. Tag someone before they start thinking you’re a statue.",
      },
      {
        "title": "Skill Issue?",
        "message":
            "They’re not that fast — you’re just making them look athletic.",
      },
      {
        "title": "Certified Menace Needed",
        "message":
            "Someone’s out there walking calmly because they know you won’t catch them.",
      },
      {
        "title": "The Hunt Continues",
        "message":
            "$taunterName is keeping score. Every second you’re it, their ego gets stronger.",
      },
      {
        "title": "Campus Predator Mode",
        "message": "Lock in. Someone near you is way too comfortable.",
      },
      {
        "title": "You Had One Job",
        "message": "Run. Tag. Transfer the shame — $taunterName is watching.",
      },
      {
        "title": "Still It? Rough.",
        "message":
            "At this point, even the squirrels are judging your footwork.",
      },
      {
        "title": "$taunterName Sends Regards",
        "message": "They’re not even hiding. Go get them.",
      },
      {
        "title": "$taunterName Is Laughing",
        "message": "Out loud. In public. About you specifically.",
      },
      {
        "title": "A Message From $taunterName",
        "message": "“Catch me. I dare you.”",
      },
    ];

    return tagTauntNotifications[DateTime.now().millisecondsSinceEpoch %
        tagTauntNotifications.length];
  }

  @override
  InAppNotification toInAppNotification() {
    return InAppNotification(
      title: title ?? "",
      body: body ?? "",
      icon: Icons.campaign,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final base = super.toMap();
    return {...base, 'taunterName': taunterName};
  }

  factory TauntNotification.fromMap(Map<String, dynamic> map) {
    return TauntNotification.withMessage(
      id: map['id'],
      targetIds: List<String>.from(map['targetIds']),
      taunterName: map['taunterName'],
      title: map['title'] ?? '',
      body: map['body'] ?? '',
    );
  }
}

class TagNotification extends Notif {
  final String taggerName;
  final String taggedName;

  factory TagNotification({
    required int id,
    required List<String> targetIds,
    required String taggerName,
    required String taggedName,
  }) {
    if (playerNotifier.value!.name == taggedName) {
      return TagNotification.withMessage(
        id: id,
        targetIds: targetIds,
        taggerName: taggerName,
        taggedName: taggedName,
        title: "You Were Tagged! 😢",
        body: "$taggerName just tagged you. Time to find a new target!",
      );
    } else {
      return TagNotification.withMessage(
        id: id,
        targetIds: targetIds,
        taggerName: taggerName,
        taggedName: taggedName,
        title: "Someone Got Tagged! 👀",
        body: "$taggerName just tagged $taggedName.",
      );
    }
  }

  TagNotification.withMessage({
    required super.id,
    required super.targetIds,
    required this.taggerName,
    required this.taggedName,
    required String super.title,
    required String super.body,
  }) : super(type: NotificationType.tag);

  @override
  InAppNotification toInAppNotification() {
    if (playerNotifier.value!.name == taggedName) {
      return InAppNotification(
        title: "You Were Tagged! 😢",
        body: "$taggerName just tagged you. Time to find a new target!",
        icon: Icons.back_hand_outlined,
      );
    } else {
      return InAppNotification(
        title: "Someone Got Tagged! 👀",
        body: "$taggerName just tagged $taggedName.",
        icon: Icons.back_hand_outlined,
      );
    }
  }

  Map<String, dynamic> toMap() {
    final base = super.toMap();
    return {...base, 'taggerName': taggerName, 'taggedName': taggedName};
  }

  factory TagNotification.fromMap(Map<String, dynamic> map) {
    return TagNotification(
      id: map['id'],
      targetIds: List<String>.from(map['targetIds']),
      taggerName: map['taggerName'],
      taggedName: map['taggedName'],
    );
  }
}

class GameStartNotification extends Notif {
  final String gameName;
  final String firstItPlayerName;

  factory GameStartNotification({
    required int id,
    required List<String> targetIds,
    required String gameName,
    required String firstItPlayerName,
  }) {
    return GameStartNotification.withMessage(
      id: id,
      targetIds: targetIds,
      gameName: gameName,
      firstItPlayerName: firstItPlayerName,
      title: "Game Started! 🎉",
      body: "The game \"$gameName\" has started. $firstItPlayerName is It!",
    );
  }

  GameStartNotification.withMessage({
    required super.id,
    required super.targetIds,
    required this.gameName,
    required this.firstItPlayerName,
    required String title,
    required String body,
  }) : super(type: NotificationType.gameStart);

  @override
  InAppNotification toInAppNotification() {
    return InAppNotification(
      title: "Game Started! 🎉",
      body: "The game \"$gameName\" has started. $firstItPlayerName is It!",
      icon: Icons.play_arrow_rounded,
    );
  }

  Map<String, dynamic> toMap() {
    final base = super.toMap();
    return {
      ...base,
      'gameName': gameName,
      'firstItPlayerName': firstItPlayerName,
    };
  }

  factory GameStartNotification.fromMap(Map<String, dynamic> map) {
    return GameStartNotification(
      id: map['id'],
      targetIds: List<String>.from(map['targetIds']),
      gameName: map['gameName'],
      firstItPlayerName: map['firstItPlayerName'],
    );
  }
}
