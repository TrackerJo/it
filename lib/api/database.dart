import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:it/api/auth.dart';
import 'package:it/api/shared_prefs.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';

class Database {
  final String? uid;
  Database({this.uid});

  final CollectionReference gameCollection = FirebaseFirestore.instance
      .collection("games");

  Future<Game> createGame(Game gameData) async {
    DocumentReference docRef = await gameCollection.add(gameData.toMap());
    await docRef.update({"id": docRef.id});
    gameData.id = docRef.id;
    return gameData;
  }

  Future<Game?> joinGame(String gameId, Player player) async {
    QuerySnapshot query = await gameCollection
        .where("joinCode", isEqualTo: int.parse(gameId))
        .get();
    if (query.docs.isEmpty) return null;
    DocumentReference docRef = query.docs.first.reference;
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) return null;
    var data = doc.data() as Map<String, dynamic>;
    Game game = Game.fromMap(data);
    game.players.add(player);
    await docRef.update(game.toMap());

    return game;
  }

  Future<Game> getGame(String gameId) async {
    DocumentSnapshot doc = await gameCollection.doc(gameId).get();
    var data = doc.data() as Map<String, dynamic>;
    return Game.fromMap(data);
  }

  Future<Game?> getGamePlayersIn(String playerId) async {
    QuerySnapshot query = await gameCollection
        .where("playerIds", arrayContains: playerId)
        .get();
    if (query.docs.isEmpty) return null;
    DocumentSnapshot doc = query.docs.first;
    var data = doc.data() as Map<String, dynamic>;
    return Game.fromMap(data);
  }

  Future<void> updateGame(Game gameData) async {
    await gameCollection.doc(gameData.id).update(gameData.toMap());
  }

  Future<void> updateGamePlayers(String gameId, List<Player> players) async {
    await gameCollection.doc(gameId).update({
      "players": players.map((p) => p.toMap()).toList(),
      "playerIds": players.map((p) => p.id).toList(),
    });
  }

  Future<void> updateGameTags(Game game) async {
    await gameCollection.doc(game.id).update({
      "tags": game.tags.map((t) => t.toMap()).toList(),
      "players": game.players.map((p) => p.toMap()).toList(),
    });
  }

  Future<void> startGame(Game game) async {
    await gameCollection.doc(game.id).update({
      "isStarted": true,
      "startedAt": game.startedAt?.millisecondsSinceEpoch,
      "players": game.players.map((p) => p.toMap()).toList(),
    });
  }

  Future<StreamSubscription> gameDataStream() async {
    String gameId =
        await SharedPrefs.getGameIdSF() ?? gameNotifier.value?.id ?? "";
    print("Starting game data stream for game with id $gameId");
    print("Current game data: ${gameNotifier.value?.toMap()}");

    Stream stream = gameCollection.doc(gameId).snapshots();

    StreamSubscription streamListen = stream.listen(
      (event) async {
        var data = event.data();
        if (data == null) return;
        final fresh = Game.fromMap(data);
        gameNotifier.value = fresh;
        playerNotifier.value = fresh.getPlayerFromId(Auth().getUserId()!);
        print(
          "Game updated from stream with id ${fresh.id} and ${fresh.players.length} players and hasStarted: ${fresh.isStarted}",
        );
      },
      onDone: () {
        print("No longer");
      },
    );
    //On Auth State change end stream
    return streamListen;
  }
}
