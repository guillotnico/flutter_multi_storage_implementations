import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> updateTheme(AppThemeMode mode);
  Future<void> updateUsername(String? username);
}
