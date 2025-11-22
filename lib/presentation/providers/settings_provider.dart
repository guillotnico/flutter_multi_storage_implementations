import 'package:flutter/foundation.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/settings/get_settings.dart';
import '../../domain/usecases/settings/update_theme.dart';
import '../../domain/usecases/settings/update_username.dart';

class SettingsProvider extends ChangeNotifier {
  final GetSettingsUseCase _getSettings;
  final UpdateThemeUseCase _updateTheme;
  final UpdateUsernameUseCase _updateUsername;

  SettingsProvider({
    required GetSettingsUseCase getSettings,
    required UpdateThemeUseCase updateTheme,
    required UpdateUsernameUseCase updateUsername,
  })  : _getSettings = getSettings,
        _updateTheme = updateTheme,
        _updateUsername = updateUsername;

  AppSettings? _settings;
  bool _isLoading = false;

  AppSettings? get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _settings = await _getSettings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeTheme(AppThemeMode mode) async {
    await _updateTheme(mode);
    await load();
  }

  Future<void> changeUsername(String? username) async {
    await _updateUsername(username);
    await load();
  }
}
