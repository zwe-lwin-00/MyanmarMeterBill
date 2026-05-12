import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user’s in-app theme choice (overrides JSON [themeMode] after first save).
class UserThemeModeStorage {
  UserThemeModeStorage._();

  static const _key = 'user_theme_mode_v1';

  /// `null` if the user has never chosen a theme in this install.
  static Future<ThemeMode?> load() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_key);
    return switch (s) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => null,
    };
  }

  static Future<void> save(ThemeMode mode) async {
    final p = await SharedPreferences.getInstance();
    final s = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await p.setString(_key, s);
  }
}
