import '../../repositories/settings_repository.dart';

class UpdateUsernameUseCase {
  final SettingsRepository repository;

  UpdateUsernameUseCase(this.repository);

  Future<void> call(String? username) => repository.updateUsername(username);
}
