import 'package:shared_preferences/shared_preferences.dart';

class AvatarStorage {
  static String _key(String userId) => 'avatar_base64_$userId';

  static Future<String?> getAvatarBase64(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key(userId));
  }

  static Future<void> setAvatarBase64(String userId, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null || value.isEmpty) {
      await prefs.remove(_key(userId));
      return;
    }
    await prefs.setString(_key(userId), value);
  }
}
