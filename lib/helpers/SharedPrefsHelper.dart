import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static final String _dateKey = "recentDt"; 

  // static Future<int> getUserId() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   return prefs.getInt(_refKey) ?? null;
  // }

  static Future<bool> setRecentFetchDt(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_dateKey, value);
  }

  static Future<String> getRecentFetch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_dateKey) ?? null;
  }

  static Future<DateTime> getRecentFetchDt() async {
    String recenFetch = await getRecentFetch();
    return DateTime.parse(recenFetch);
  }
}
