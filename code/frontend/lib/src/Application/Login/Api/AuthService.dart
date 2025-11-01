import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'TokenStorage.dart';
import 'package:frontend/src/routes/ApiRoutes.dart';

/// Role enum matching backend UserRole type
enum Role { administrator, manager, user }

/// Extension to convert backend role strings to Role enum
extension RoleExtension on String {
  Role toRole() {
    switch (toLowerCase()) {
      case 'administrator':
        return Role.administrator;
      case 'manager':
        return Role.manager;
      case 'user':
      default:
        return Role.user;
    }
  }
}

/// User model matching backend response
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final Role role;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: (json['role'] as String? ?? 'User').toRole(),
    );
  }
}


class AuthService extends ChangeNotifier {
  static String get baseUrl => dotenv.env['API_URL']!;
  
  User? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  bool _isInitialized = false;

  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  User? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _currentUser != null && _accessToken != null;
  bool get isInitialized => _isInitialized;

  /// Initialize the auth service and load stored tokens
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      await TokenStorage.instance.init();
      
      // Try to load stored tokens
      _accessToken = await TokenStorage.instance.getAccessToken();
      _refreshToken = await TokenStorage.instance.getRefreshToken();
      
      // If we have tokens, try to get user info or refresh
      if (_accessToken != null && _refreshToken != null) {
        try {
          // Try to use the access token to get user info
          await loadUserInfo();
        } catch (e) {
          // If access token is expired, try to refresh
          try {
            await refreshAccessToken();
          } catch (refreshError) {
            // If refresh fails, clear everything
            await logout();
          }
        }
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = true;
      debugPrint('Auth initialization error: $e');
    }
  }

  /// Load user information using the current access token
  Future<void> loadUserInfo() async {
    // if (_accessToken == null) return;
    
    // Uncomment and use the real HTTP request when backend is available:
    // final response = await http.get(
    //   Uri.parse('$baseUrl${ApiRoutes.userMe}'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $_accessToken',
    //   },
    // );
    //
    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   _currentUser = User.fromJson(data['data'] as Map<String, dynamic>);
    //   notifyListeners();
    // } else {
    //   throw Exception('Failed to load user info');
    // }

    // Temporary/mock user assignment for local development
    _currentUser = User(
      id: '1',
      email: 'ytc@mail.com',
      firstName: 'Yann',
      lastName: 'T.C.',
      role: 'Administrator'.toRole(),
    );
    notifyListeners();
    print(_currentUser?.role);
  }

  /// Sign in with email and password
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiRoutes.signin}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authData = data['data'] as Map<String, dynamic>;
        
        _accessToken = authData['accessToken'] as String;
        _refreshToken = authData['refreshToken'] as String;
        _currentUser = User.fromJson(authData['user'] as Map<String, dynamic>);
        
        // Save tokens to secure storage
        await TokenStorage.instance.saveTokens(
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        );
        
        notifyListeners();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sign up with email, password, and optional names
  Future<void> signup({
    required String email,
    required String password,
    required String confirmPassword,
    String firstName = '',
    String lastName = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiRoutes.signup}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final authData = data['data'] as Map<String, dynamic>;
        
        _accessToken = authData['accessToken'] as String;
        _refreshToken = authData['refreshToken'] as String;
        _currentUser = User.fromJson(authData['user'] as Map<String, dynamic>);
        
        // Save tokens to secure storage
        await TokenStorage.instance.saveTokens(
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        );
        
        notifyListeners();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Signup failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh access token using refresh token
  Future<void> refreshAccessToken() async {
    if (_refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiRoutes.refreshToken}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': _refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authData = data['data'] as Map<String, dynamic>;
        
        _accessToken = authData['accessToken'] as String;
        // Keep the existing refresh token if a new one isn't provided
        _refreshToken = authData['refreshToken'] as String? ?? _refreshToken;
        
        // Save updated tokens
        await TokenStorage.instance.saveTokens(
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        );
        
        notifyListeners();
      } else {
        // If refresh fails, clear auth state
        await logout();
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Log out and clear all stored tokens
  Future<void> logout() async {
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    
    await TokenStorage.instance.clearAllTokens();
    
    notifyListeners();
  }
}
