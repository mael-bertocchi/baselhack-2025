import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'http_client_factory.dart';
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
  bool _isInitialized = false;
  final http.Client _httpClient = createHttpClient();

  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  /// Initialize the auth service and load stored tokens
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      await loadUserInfo();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = true;
      debugPrint('Auth initialization error: $e');
      notifyListeners();
    }
  }

  /// Load user information using the current access token
  Future<void> loadUserInfo() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl${ApiRoutes.userMe}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final userData = ((data['data'] as Map<String, dynamic>?)?['user'] ??
                data['data']) as Map<String, dynamic>?;

        if (userData == null) {
          throw Exception('User data is missing from the response');
        }

        _currentUser = User.fromJson(userData);
        notifyListeners();
      } else if (response.statusCode == 401) {
        _currentUser = null;
        notifyListeners();
        throw Exception('User not authenticated');
      } else {
        throw Exception('Failed to load user info (status ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Failed to load user info: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<void> login(String email, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl${ApiRoutes.signin}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final payload = data['data'] as Map<String, dynamic>?;
        final userData = payload?['user'] as Map<String, dynamic>?;

        if (userData == null) {
          throw Exception('User information is missing in the response');
        }

        _currentUser = User.fromJson(userData);

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
      final response = await _httpClient.post(
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
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final payload = data['data'] as Map<String, dynamic>?;
        final userData = payload?['user'] as Map<String, dynamic>?;

        if (userData == null) {
          throw Exception('User information is missing in the response');
        }

        _currentUser = User.fromJson(userData);

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
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl${ApiRoutes.refreshToken}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
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
    notifyListeners();
  }
}
