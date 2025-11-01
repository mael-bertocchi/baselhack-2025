import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/src/routes/ApiRoutes.dart';
import 'package:frontend/src/Application/TopicDetail/UI/Idea.dart';
import 'package:frontend/src/Application/Login/Api/TokenStorage.dart';

/// Service pour gérer les soumissions (submissions) des topics
class TopicSubmissionService {
  // Singleton pattern
  static final TopicSubmissionService _instance = TopicSubmissionService._internal();
  factory TopicSubmissionService() => _instance;
  TopicSubmissionService._internal();

  static String get baseUrl => dotenv.env['API_URL']!;

  /// Récupère le token d'accès pour l'authentification
  Future<String?> _getAccessToken() async {
    return await TokenStorage.instance.getAccessToken();
  }

  /// Récupère toutes les soumissions (idées) pour un topic spécifique
  Future<List<Idea>> getSubmissions(String topicId) async {
    try {
      final accessToken = await _getAccessToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl${ApiRoutes.topics}/$topicId/submissions'),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> submissionsData = responseData['data'] as List<dynamic>;
        
        // Mapper les données de l'API vers des objets Idea
        return submissionsData.map((submissionJson) {
          return Idea(
            id: submissionJson['_id'] as String? ?? submissionJson['id'] as String,
            content: submissionJson['text'] as String,
            authorId: submissionJson['authorId'] as String? ?? 'anonymous',
            createdAt: DateTime.parse(submissionJson['createdAt'] as String),
          );
        }).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to load submissions');
      }
    } catch (e) {
      print('Error fetching submissions: $e');
      rethrow;
    }
  }

  /// Soumet une nouvelle idée pour un topic
  Future<Idea> submitIdea(String topicId, String text) async {
    try {
      final accessToken = await _getAccessToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl${ApiRoutes.topics}/$topicId/submissions'),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'text': text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final submissionData = responseData['data'] as Map<String, dynamic>;
        
        return Idea(
          id: submissionData['_id'] as String? ?? submissionData['id'] as String,
          content: submissionData['text'] as String,
          authorId: submissionData['authorId'] as String? ?? 'anonymous',
          createdAt: DateTime.parse(submissionData['createdAt'] as String),
        );
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to submit idea');
      }
    } catch (e) {
      print('Error submitting idea: $e');
      rethrow;
    }
  }

  /// Récupère le résumé d'un topic (pour les admins)
  Future<Map<String, dynamic>> getTopicSummary(String topicId) async {
    try {
      final accessToken = await _getAccessToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl${ApiRoutes.topics}/$topicId/summary'),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] as Map<String, dynamic>;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to load topic summary');
      }
    } catch (e) {
      print('Error fetching topic summary: $e');
      rethrow;
    }
  }
}
