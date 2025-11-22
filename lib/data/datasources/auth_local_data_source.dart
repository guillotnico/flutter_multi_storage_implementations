import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyToken = 'auth.token';

  @override
  Future<String?> getToken() => _storage.read(key: _keyToken);

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  @override
  Future<void> clearToken() => _storage.delete(key: _keyToken);
}
