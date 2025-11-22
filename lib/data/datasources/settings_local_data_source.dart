import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettings> getSettings();
  Future<void> setThemeMode(AppThemeMode mode);
  Future<void> setUsername(String? username);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _keyTheme = 'settings.theme';
  static const _keyUsername = 'settings.username';

  int _encodeTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 0;
      case AppThemeMode.light:
        return 1;
      case AppThemeMode.dark:
        return 2;
    }
  }

  AppThemeMode _decodeTheme(int? value) {
    switch (value) {
      case 1:
        return AppThemeMode.light;
      case 2:
        return AppThemeMode.dark;
      case 0:
      default:
        return AppThemeMode.system;
    }
  }

  @override
  Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeInt = prefs.getInt(_keyTheme);
    final username = prefs.getString(_keyUsername);

    return AppSettings(
      themeMode: _decodeTheme(themeInt),
      username: username,
    );
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTheme, _encodeTheme(mode));
  }

  @override
  Future<void> setUsername(String? username) async {
    final prefs = await SharedPreferences.getInstance();
    if (username == null || username.isEmpty) {
      await prefs.remove(_keyUsername);
    } else {
      await prefs.setString(_keyUsername, username);
    }
  }
}
