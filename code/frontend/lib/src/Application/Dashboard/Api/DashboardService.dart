import 'package:alignify/src/Application/Login/Api/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:alignify/src/routes/ApiRoutes.dart';
import 'package:alignify/src/Application/Dashboard/UI/Components/TopicCard.dart';

/// Service pour gérer les appels API du dashboard
class DashboardApiService {
  // Singleton pattern
  static final DashboardApiService _instance = DashboardApiService._internal();
  factory DashboardApiService() => _instance;
  DashboardApiService._internal();

  static String get baseUrl => dotenv.env['API_URL']!;

  /// Récupère la liste des topics depuis l'API
  Future<List<Topic>> getTopics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiRoutes.topics}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${AuthService.instance.accessToken}'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> topicsData = responseData['data'] as List<dynamic>;
        
        // Mapper les données de l'API vers des objets Topic avec le nombre de soumissions
        final topics = await Future.wait(topicsData.map((topicJson) async {
          final topicId = topicJson['_id'] as String;
          
          // Récupérer le nombre de soumissions pour ce topic
          int nbSubmissions = 0;
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

  /// Mappe le statut de l'API vers l'enum TopicStatus
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

  /// Récupère le nombre total de topics
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

  /// Récupère le nombre total d'utilisateurs
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

  /// Récupère le nombre total de soumissions
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

  /// Récupère toutes les statistiques du dashboard en parallèle
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

  /// Récupère un topic spécifique par son ID
  Future<Topic?> getTopicById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiRoutes.topics}/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${AuthService.instance.accessToken}'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final topicJson = responseData['data'] as Map<String, dynamic>;
        
        // Récupérer le nombre de soumissions pour ce topic
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

  /// Recherche des topics par mots-clés
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

  /// Supprime un topic par son ID
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
}
