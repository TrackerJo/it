import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String gameIdKey = "GAMEIDKEY";


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
