import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:alignify/src/routes/ApiRoutes.dart';
import 'package:alignify/src/Application/Shared/Models/Models.dart';
import 'TokenStorage.dart';
import 'AuthService.dart';

/// Consolidated service for managing all topic-related API calls
/// Includes topic CRUD, submissions, results, and statistics
class TopicService {
  // Singleton pattern
  static final TopicService _instance = TopicService._internal();
  factory TopicService() => _instance;
  TopicService._internal();

  static String get baseUrl => dotenv.env['API_URL']!;

  /// Get access token for authentication
  Future<String?> _getAccessToken() async {
    return await TokenStorage.instance.getAccessToken();
  }

  // ==================== TOPIC CRUD OPERATIONS ====================

  /// Get all topics from the API
  Future<List<Topic>> getTopics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiRoutes.topics}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> topicsData = responseData['data'] as List<dynamic>;
        
        // Map API data to Topic objects with submission count
        final topics = await Future.wait(topicsData.map((topicJson) async {
          final topicId = topicJson['_id'] as String;
          
          // Get submission count for this topic
          int nbSubmissions = 0;
          bool hasAiResult = false;
          try {
            final submissionsResponse = await http.get(
              Uri.parse('$baseUrl${ApiRoutes.topics}/$topicId/submissions'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${AuthService.instance.accessToken}'
              },
            );
            
            if (submissionsResponse.statusCode == 200) {
              final submissionsData = jsonDecode(submissionsResponse.body);
              final List<dynamic> submissions = submissionsData['data'] as List<dynamic>;
              nbSubmissions = submissions.length;
            }
          } catch (e) {
            print('Error fetching submissions for topic $topicId: $e');
          }
          
          // Check if topic has AI result
          try {
            final aiResultResponse = await http.get(
              Uri.parse('$baseUrl/v1/topic-results/$topicId'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${AuthService.instance.accessToken}'
              },
            );
            
            if (aiResultResponse.statusCode == 200) {
              hasAiResult = true;
            }
          } catch (e) {
            // AI result doesn't exist, that's ok
          }
          
          return Topic(
            id: topicId,
            title: topicJson['title'] as String,
            shortDescription: topicJson['short_description'] as String,
            description: topicJson['description'] as String,
            startDate: DateTime.parse(topicJson['startDate'] as String),
            endDate: DateTime.parse(topicJson['endDate'] as String),
            createdAt: DateTime.parse(topicJson['createdAt'] as String),
            updatedAt: DateTime.parse(topicJson['updatedAt'] as String),
            status: _mapApiStatusToTopicStatus(topicJson['status'] as String),
            authorId: topicJson['authorId'] as String,
            nbSubmissions: nbSubmissions,
            hasAiResult: hasAiResult,
          );
        }));
        
        return topics;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to load topics');
      }
    } catch (e) {
      print('Error fetching topics: $e');
      rethrow;
    }
  }

  /// Get a specific topic by ID
  Future<Topic?> getTopicById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiRoutes.topics}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final topicJson = responseData['data'] as Map<String, dynamic>;
        
        // Get submission count for this topic
        int nbSubmissions = 0;
        try {
          final submissionsResponse = await http.get(
            Uri.parse('$baseUrl${ApiRoutes.topics}/$id/submissions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AuthService.instance.accessToken}'
            },
          );
          
          if (submissionsResponse.statusCode == 200) {
            final submissionsData = jsonDecode(submissionsResponse.body);
            final List<dynamic> submissions = submissionsData['data'] as List<dynamic>;
            nbSubmissions = submissions.length;
          }
        } catch (e) {
          print('Error fetching submissions for topic $id: $e');
        }
        
        return Topic(
          id: topicJson['_id'] as String,
          title: topicJson['title'] as String,
          shortDescription: topicJson['short_description'] as String,
          description: topicJson['description'] as String,
          startDate: DateTime.parse(topicJson['startDate'] as String),
          endDate: DateTime.parse(topicJson['endDate'] as String),
          createdAt: DateTime.parse(topicJson['createdAt'] as String),
          updatedAt: DateTime.parse(topicJson['updatedAt'] as String),
          status: _mapApiStatusToTopicStatus(topicJson['status'] as String),
          authorId: topicJson['authorId'] as String,
          nbSubmissions: nbSubmissions,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching topic by id: $e');
      return null;
    }
  }

  /// Create a new topic
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
      final token = await _getAccessToken();
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

  /// Update an existing topic
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
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
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

  /// Delete a topic by ID
  Future<bool> deleteTopic(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl${ApiRoutes.topics}/$id'),
        headers: {
          'Authorization': 'Bearer ${AuthService.instance.accessToken}'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete topic');
      }
    } catch (e) {
      print('Error deleting topic: $e');
      rethrow;
    }
  }

  /// Search topics by keywords
  Future<List<Topic>> searchTopics(String query) async {
    final allTopics = await getTopics();
    
    if (query.isEmpty) return allTopics;
    
    final lowerQuery = query.toLowerCase();
    return allTopics.where((topic) {
      return topic.title.toLowerCase().contains(lowerQuery) ||
          topic.shortDescription.toLowerCase().contains(lowerQuery) ||
          topic.description.toLowerCase().contains(lowerQuery) ||
          topic.statusDisplay.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // ==================== SUBMISSIONS ====================

  /// Get all submissions (ideas) for a specific topic
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

  /// Submit a new idea for a topic
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

  /// Get topic summary (for admins)
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

  // ==================== TOPIC RESULTS (AI Analysis) ====================

  /// Get the AI analysis result for a specific topic
  /// Returns null if no analysis has been performed yet
  Future<TopicResult?> getTopicResult(String topicId) async {
    try {
      final token = await _getAccessToken();
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
      final token = await _getAccessToken();
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
      final token = await _getAccessToken();
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

  // ==================== STATISTICS ====================

  /// Get total number of topics
  Future<int> getNbTopics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/stats/nbTopics'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] as int;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch number of topics');
      }
    } catch (e) {
      print('Error fetching nbTopics: $e');
      return 0;
    }
  }

  /// Get total number of users
  Future<int> getNbUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/stats/nbUsers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] as int;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch number of users');
      }
    } catch (e) {
      print('Error fetching nbUsers: $e');
      return 0;
    }
  }

  /// Get total number of submissions
  Future<int> getNbSubmissions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/stats/nbSubmission'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] as int;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch number of submissions');
      }
    } catch (e) {
      print('Error fetching nbSubmissions: $e');
      return 0;
    }
  }

  /// Get all dashboard statistics in parallel
  Future<Map<String, int>> getDashboardStats() async {
    try {
      final results = await Future.wait([
        getNbTopics(),
        getNbUsers(),
        getNbSubmissions(),
      ]);

      return {
        'nbTopics': results[0],
        'nbUsers': results[1],
        'nbSubmissions': results[2],
      };
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return {
        'nbTopics': 0,
        'nbUsers': 0,
        'nbSubmissions': 0,
      };
    }
  }

  /// Get topics sorted by submission count (most popular first)
  Future<List<Map<String, dynamic>>> getSortedTopics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/stats/sortTopics'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] as List<dynamic>;
        return data.map((item) => {
          'topicId': item['topicId'] as String,
          'title': item['title'] as String,
          'submissionCount': item['submissionCount'] as int,
        }).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch sorted topics');
      }
    } catch (e) {
      print('Error fetching sorted topics: $e');
      return [];
    }
  }

  // ==================== HELPER METHODS ====================

  /// Map API status string to TopicStatus enum
  TopicStatus _mapApiStatusToTopicStatus(String apiStatus) {
    switch (apiStatus.toLowerCase()) {
      case 'scheduled':
      case 'open':
        return TopicStatus.open;
      case 'closed':
        return TopicStatus.closed;
      case 'archived':
        return TopicStatus.archived;
      default:
        return TopicStatus.open;
    }
  }
}
