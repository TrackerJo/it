import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';

class PushNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
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

    final notif = Notif.fromMap(message.data);
  }

  void handleInAppMessage(RemoteMessage? message) async {
    if (message == null) {
      return;
    }
    final notif = Notif.fromMap(message.data);
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
}
