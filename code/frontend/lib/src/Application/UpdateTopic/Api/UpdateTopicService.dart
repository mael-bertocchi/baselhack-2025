import 'package:alignify/src/Application/Login/Api/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:alignify/src/routes/ApiRoutes.dart';

/// Service pour gérer la mise à jour des topics
class UpdateTopicService {
  // Singleton pattern
  static final UpdateTopicService _instance = UpdateTopicService._internal();
  factory UpdateTopicService() => _instance;
  UpdateTopicService._internal();

  static String get baseUrl => dotenv.env['API_URL']!;

  /// Met à jour un topic existant
  Future<void> updateTopic({
    required String id,
    required String title,
    required String shortDescription,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String authorId,
  }) async {
    try {
      final requestBody = {
        'title': title,
        'short_description': shortDescription,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'authorId': authorId,
      };

      final response = await http.put(
        Uri.parse('$baseUrl${ApiRoutes.topics}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.instance.accessToken}',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Success
        return;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update topic');
      }
    } catch (e) {
      print('Error updating topic: $e');
      rethrow;
    }
  }
}
