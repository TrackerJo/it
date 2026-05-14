import 'package:flutter/material.dart';
import 'package:it/api/auth.dart';
import 'package:it/api/database.dart';
import 'package:it/api/shared_prefs.dart';
import 'package:it/api/widget_service.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> init() async {
    String? gameId = await SharedPrefs.getGameIdSF();
    bool isLoggedIn = Auth().isUserLoggedIn();

    if (!isLoggedIn) {
      router.pushReplacement("/welcome");
    } else if (gameId == null) {
      Game? game = await Database().getGamePlayersIn(Auth().getUserId()!);
      if (game != null) {
        await SharedPrefs.setGameIdSF(game.id);
        gameNotifier.value = game;
        playerNotifier.value = game.getPlayerFromId(Auth().getUserId()!);
        WidgetService.updateTaggedState(
          TagState(
            isIt: game.itPlayer!.id == playerNotifier.value!.id,
            itName: game.itPlayer!.name,
          ),
        );
        router.pushReplacement("/home");

        return;
      }
      router.pushReplacement("/onboarding");
    }

    gameNotifier.addListener(() {
      if (gameNotifier.value != null) {
        WidgetService.updateTaggedState(
          TagState(
            isIt: gameNotifier.value!.itPlayer!.id == Auth().getUserId(),
            itName: gameNotifier.value!.itPlayer!.name,
          ),
        );
        router.pushReplacement("/home");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: styling.green,
      body: Center(child: CircularProgressIndicator(color: styling.blue)),
    );
  }
}
