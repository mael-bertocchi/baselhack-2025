import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/src/routes/ApiRoutes.dart';
import 'package:frontend/src/Application/Login/Api/TokenStorage.dart';
import 'package:frontend/src/Application/Login/Api/AuthService.dart';

/// Model pour un utilisateur dans la liste de gestion
class UserAccount {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final Role role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAccount({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      role: _parseRole(json['role'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static Role _parseRole(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'administrator':
        return Role.administrator;
      case 'manager':
        return Role.manager;
      case 'user':
        return Role.user;
      default:
        return Role.user;
    }
  }

  String get fullName => '$firstName $lastName';
}

/// Service pour gérer les utilisateurs
class UserManagementService {
  // Singleton pattern
  static final UserManagementService _instance = UserManagementService._internal();
  factory UserManagementService() => _instance;
  UserManagementService._internal();

  static String get baseUrl => dotenv.env['API_URL']!;

  /// Récupère la liste de tous les utilisateurs
  Future<List<UserAccount>> getAllUsers() async {
    try {
      // Récupérer le token d'authentification
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

  /// Change le mot de passe d'un utilisateur
  Future<UserAccount> changePassword(String userId, String newPassword) async {
    try {
      // Récupérer le token d'authentification
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
}
