import '../../entities/app_settings.dart';
import '../../repositories/settings_repository.dart';

class UpdateThemeUseCase {
  final SettingsRepository repository;

  UpdateThemeUseCase(this.repository);

  Future<void> call(AppThemeMode mode) => repository.updateTheme(mode);
}
