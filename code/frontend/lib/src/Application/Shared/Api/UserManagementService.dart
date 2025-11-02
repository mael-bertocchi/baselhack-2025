import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:alignify/src/routes/ApiRoutes.dart';
import 'package:alignify/src/Application/Shared/Models/Models.dart';
import 'TokenStorage.dart';

/// Service for managing user accounts
class UserManagementService {
  // Singleton pattern
  static final UserManagementService _instance = UserManagementService._internal();
  factory UserManagementService() => _instance;
  UserManagementService._internal();

  static String get baseUrl => dotenv.env['API_URL']!;

  /// Get all users
  Future<List<UserAccount>> getAllUsers() async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl${ApiRoutes.users.path}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> usersJson = responseData['data'] as List<dynamic>;
        return usersJson.map((json) => UserAccount.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  /// Change user password
  Future<UserAccount> changePassword(String userId, String newPassword) async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.patch(
        Uri.parse('$baseUrl${ApiRoutes.changePassword.path}/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UserAccount.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  /// Change user role
  Future<UserAccount> changeRole(String userId, Role newRole) async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Convert Role enum to string
      String roleString;
      switch (newRole) {
        case Role.administrator:
          roleString = 'Administrator';
          break;
        case Role.manager:
          roleString = 'Manager';
          break;
        case Role.user:
          roleString = 'User';
          break;
      }

      final response = await http.patch(
        Uri.parse('$baseUrl${ApiRoutes.changeRole.path}/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'role': roleString,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UserAccount.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to change role');
      }
    } catch (e) {
      print('Error changing role: $e');
      rethrow;
    }
  }

  /// Create a new user
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl${ApiRoutes.signup.path}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create user');
      }
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl${ApiRoutes.users.path}/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}
