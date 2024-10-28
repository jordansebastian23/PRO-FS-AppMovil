import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> setLoginType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loginType', type);
  }

  static Future<String?> getLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loginType');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('loginType');
  }
}
