import '../../repositories/auth_repository.dart';

class ClearTokenUseCase {
  final AuthRepository repository;

  ClearTokenUseCase(this.repository);

  Future<void> call() => repository.clearToken();
}
