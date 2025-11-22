enum AppThemeMode { system, light, dark }

class AppSettings {
  final AppThemeMode themeMode;
  final String? username;

  const AppSettings({
    required this.themeMode,
    this.username,
  });

  AppSettings copyWith({
    AppThemeMode? themeMode,
    String? username,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      username: username ?? this.username,
    );
  }
}
