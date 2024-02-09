import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<bool> saveVisibility(String id, bool isHidden) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(id, isHidden);
  }

  static bool? getVisibility(String id) {
    SharedPreferences prefs =
        SharedPreferences.getInstance() as SharedPreferences;
    return prefs.getBool(id);
  }
}
