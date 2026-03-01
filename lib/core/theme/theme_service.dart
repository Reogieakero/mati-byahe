import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeModeKey = 'theme_mode';
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
    ThemeMode.light,
  );

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_themeModeKey) ?? 'light';
    themeModeNotifier.value = _parseThemeMode(raw);
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeModeToString(mode));
  }

  static Future<void> toggleDarkMode(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  static bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  static ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }
}
