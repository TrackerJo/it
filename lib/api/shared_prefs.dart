import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String gameIdKey = "GAMEIDKEY";
  static String askedNotificationsKey = "ASKEDNOTIFICATIONSKEY";

  static Future<void> setAskedNotificationsSF(bool asked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(askedNotificationsKey, asked);
  }

  static Future<bool> getAskedNotificationsSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? asked = prefs.getBool(askedNotificationsKey);
    return asked ?? false;
  }

  static Future<void> setGameIdSF(String? gameId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (gameId == null) {
      await prefs.remove(gameIdKey);
      return;
    }
    await prefs.setString(gameIdKey, gameId);
  }

  static Future<String?> getGameIdSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gameId = prefs.getString(gameIdKey);
    return gameId;
  }
}
