import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for securely storing authentication tokens
/// Uses flutter_secure_storage for mobile/desktop and shared_preferences for web
class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  // Secure storage for mobile/desktop
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  
  // Shared preferences for web (fallback)
  SharedPreferences? _prefs;
  
  TokenStorage._internal();
  static final TokenStorage instance = TokenStorage._internal();
  
  /// Initialize the storage (must be called before use, especially for web)
  Future<void> init() async {
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
    }
  }
  
  /// Save access token
  Future<void> saveAccessToken(String token) async {
    if (kIsWeb) {
      await _prefs?.setString(_accessTokenKey, token);
    } else {
      await _secureStorage.write(key: _accessTokenKey, value: token);
    }
  }
  
  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    if (kIsWeb) {
      await _prefs?.setString(_refreshTokenKey, token);
    } else {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
    }
  }
  
  /// Save both tokens at once
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }
  
  /// Get access token
  Future<String?> getAccessToken() async {
    if (kIsWeb) {
      return _prefs?.getString(_accessTokenKey);
    } else {
      return await _secureStorage.read(key: _accessTokenKey);
    }
  }
  
  /// Get refresh token
  Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      return _prefs?.getString(_refreshTokenKey);
    } else {
      return await _secureStorage.read(key: _refreshTokenKey);
    }
  }
  
  /// Delete access token
  Future<void> deleteAccessToken() async {
    if (kIsWeb) {
      await _prefs?.remove(_accessTokenKey);
    } else {
      await _secureStorage.delete(key: _accessTokenKey);
    }
  }
  
  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    if (kIsWeb) {
      await _prefs?.remove(_refreshTokenKey);
    } else {
      await _secureStorage.delete(key: _refreshTokenKey);
    }
  }
  
  /// Clear all tokens
  Future<void> clearAllTokens() async {
    await Future.wait([
      deleteAccessToken(),
      deleteRefreshToken(),
    ]);
  }
  
  /// Check if tokens exist
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }
}
