import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String gameIdKey = "GAMEIDKEY";
  static String askedNotificationsKey = "ASKEDNOTIFICATIONSKEY";
  static String lastTauntedKey = "LASTTAUNTEDKEY";

  static Future<void> setLastTauntedSF(DateTime? time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (time == null) {
      await prefs.remove(lastTauntedKey);
      return;
    }
    await prefs.setInt(lastTauntedKey, time.millisecondsSinceEpoch);
  }

  static Future<DateTime?> getLastTauntedSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? time = prefs.getInt(lastTauntedKey);
    if (time == null) return null;
    // return null;
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

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
