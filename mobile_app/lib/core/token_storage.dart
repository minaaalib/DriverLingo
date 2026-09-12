import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps secure, encrypted storage for the JWT access/refresh token pair.
class TokenStorage {
  TokenStorage._internal();
  static final TokenStorage instance = TokenStorage._internal();

  final _storage = const FlutterSecureStorage();

  static const _accessKey = 'lto_access_token';
  static const _refreshKey = 'lto_refresh_token';

  Future<void> saveTokens({required String access, required String refresh}) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  Future<void> saveAccessToken(String access) => _storage.write(key: _accessKey, value: access);

  Future<String?> get accessToken => _storage.read(key: _accessKey);
  Future<String?> get refreshToken => _storage.read(key: _refreshKey);

  Future<bool> get hasSession async => (await accessToken) != null;

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
