import 'package:flutter/foundation.dart';

import '../../domain/usecases/auth/clear_token.dart';
import '../../domain/usecases/auth/get_token.dart';
import '../../domain/usecases/auth/save_token.dart';

class AuthProvider extends ChangeNotifier {
  final GetTokenUseCase _getToken;
  final SaveTokenUseCase _saveToken;
  final ClearTokenUseCase _clearToken;

  AuthProvider({
    required GetTokenUseCase getToken,
    required SaveTokenUseCase saveToken,
    required ClearTokenUseCase clearToken,
  })  : _getToken = getToken,
        _saveToken = saveToken,
        _clearToken = clearToken;

  String? _token;
  bool _isLoading = false;

  String? get token => _token;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _token = await _getToken();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> save(String token) async {
    await _saveToken(token);
    await load();
  }

  Future<void> clear() async {
    await _clearToken();
    await load();
  }
}
