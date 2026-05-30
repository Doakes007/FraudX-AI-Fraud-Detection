import 'package:shared_preferences/shared_preferences.dart';

class IPConfig {
  static const String _key = 'backend_ip';

  // Save backend IP to shared preferences
  static Future<void> setBackendIP(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, ip);
  }

  // Retrieve saved backend IP (or return null)
  static Future<String?> getBackendIP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}

