import '../../repositories/auth_repository.dart';

class SaveTokenUseCase {
  final AuthRepository repository;

  SaveTokenUseCase(this.repository);

  Future<void> call(String token) => repository.saveToken(token);
}
