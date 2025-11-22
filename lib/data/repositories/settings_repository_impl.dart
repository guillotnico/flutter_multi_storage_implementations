import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<AppSettings> getSettings() => localDataSource.getSettings();

  @override
  Future<void> updateTheme(AppThemeMode mode) =>
      localDataSource.setThemeMode(mode);

  @override
  Future<void> updateUsername(String? username) =>
      localDataSource.setUsername(username);
}
