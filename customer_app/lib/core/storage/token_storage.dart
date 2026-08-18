import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final storage = TokenStorage(const FlutterSecureStorage());
  ref.onDispose(() => storage.dispose());
  return storage;
});

class TokenStorage {
  final FlutterSecureStorage _storage;
  final _clearedController = StreamController<void>.broadcast();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  TokenStorage(this._storage);

  Stream<void> get onTokensCleared => _clearedController.stream;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    _clearedController.add(null);
  }

  void dispose() {
    _clearedController.close();
  }
}
