import 'package:alignify/src/Application/Login/Api/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:alignify/src/routes/ApiRoutes.dart';
import 'package:alignify/src/Application/Login/Api/TokenStorage.dart';

/// Service pour gérer la création de topics
class CreateTopicService {
  // Singleton pattern
  static final CreateTopicService _instance = CreateTopicService._internal();
  factory CreateTopicService() => _instance;
  CreateTopicService._internal();

  static String get baseUrl => dotenv.env['API_URL']!;

  /// Crée un nouveau topic
  Future<Map<String, dynamic>> createTopic({
    required String title,
    required String shortDescription,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String authorId,
    String status = 'open',
  }) async {
    try {
      // Récupérer le token d'authentification
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final body = jsonEncode({
        'title': title,
        'short_description': shortDescription,
        'description': description,
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
        'status': status,
        'authorId': '${AuthService.instance.currentUser!.firstName} ${AuthService.instance.currentUser!.lastName}',
      });

      final response = await http.post(
        Uri.parse('$baseUrl${ApiRoutes.topics.path}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] as Map<String, dynamic>;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create topic');
      }
    } catch (e) {
      print('Error creating topic: $e');
      rethrow;
    }
  }
}
