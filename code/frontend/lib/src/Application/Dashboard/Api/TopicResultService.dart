import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../Login/Api/TokenStorage.dart';

class TopicResult {
  final String topicId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TopicResult({
    required this.topicId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TopicResult.fromJson(Map<String, dynamic> json) {
    return TopicResult(
      topicId: json['topicId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class TopicResultService {
  static String get baseUrl => dotenv.env['API_URL']!;

  /// Get the AI analysis result for a specific topic
  /// Returns null if no analysis has been performed yet
  Future<TopicResult?> getTopicResult(String topicId) async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/v1/topic-results/$topicId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TopicResult.fromJson(data['data'] as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        // No analysis exists yet
        return null;
      } else {
        throw Exception('Failed to load topic result: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Trigger AI analysis for a topic
  /// This will aggregate all submissions and generate an AI summary
  Future<TopicResult> analyzeTopic(String topicId) async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/v1/topic-results/analyze/$topicId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TopicResult.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to analyze topic');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get all topic results
  Future<List<TopicResult>> getAllTopicResults() async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/v1/topic-results'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data'] as List;
        return results
            .map((json) => TopicResult.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load topic results');
      }
    } catch (e) {
      rethrow;
    }
  }
}
