import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:it/api/database.dart';
import 'package:it/api/shared_prefs.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';

class PushNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    NotificationSettings notificationSettings = await _firebaseMessaging
        .requestPermission();
    await SharedPrefs.setAskedNotificationsSF(true);
    if (notificationSettings.authorizationStatus !=
        AuthorizationStatus.authorized) {
      print("Notification permissions not granted");
      return;
    }
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
    if (token != null) {
      Player? player = playerNotifier.value;
      if (player != null && player.fcmToken != token) {
        player.fcmToken = token;
        Database().updateGamePlayers(
          gameNotifier.value!.id,
          gameNotifier.value!.players,
        );
      }
    }
    initPushNotifications();
  }

  Future<bool?> getNotificationsEnabled() async {
    NotificationSettings settings = await _firebaseMessaging
        .getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return false;
    } else {
      return null; // Permission not determined
    }
  }

  void handleMessage(RemoteMessage? message) async {
    if (message == null) {
      return;
    }
    //Check if user is logged in

    final notif = Notif.fromMap(jsonDecode(message.data["data"]));
  }

  void handleInAppMessage(RemoteMessage? message) async {
    if (message == null) {
      return;
    }
    final notif = Notif.fromMap(jsonDecode(message.data["data"]));
    notif.toInAppNotification().present(
      router.routerDelegate.navigatorKey.currentContext!,
    );
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onMessage.listen((message) {
      handleInAppMessage(message);
    });
  }

  Future sendNotification({required Notif notif}) async {
    print("Sending notification: ${notif.targetIds}");
    try {
      FirebaseFunctions.instance.httpsCallable('sendNotifications').call({
        "title": notif.title,
        "body": notif.body,
        "type": notif.type.toString(),
        "targetIds": notif.targetIds,
        "data": jsonEncode(notif.toMap()),
      });
    } on FirebaseFunctionsException catch (error) {
      print("ERROR:${error.message!}");
    }
  }
}
