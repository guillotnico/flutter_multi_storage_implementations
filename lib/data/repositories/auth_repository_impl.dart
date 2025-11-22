import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<String?> getToken() => localDataSource.getToken();

  @override
  Future<void> saveToken(String token) => localDataSource.saveToken(token);

  @override
  Future<void> clearToken() => localDataSource.clearToken();
}
