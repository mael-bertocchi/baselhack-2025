import 'package:frontend/src/Application/Login/Api/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/src/routes/ApiRoutes.dart';
import 'package:frontend/src/Application/Dashboard/UI/Components/TopicCard.dart';

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
        
        // Mapper les données de l'API vers des objets Topic
        return topicsData.map((topicJson) {
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
          );
        }).toList();
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

  /// Récupère les statistiques du dashboard
  Future<Map<String, int>> getDashboardStats() async {
    try {
      // TODO: Créer une route API pour les stats
      // Pour l'instant, on calcule depuis les topics
      final topics = await getTopics();
      final activeCount = topics.where((t) => t.isActive).length;
      
      return {
        'activeTopics': activeCount,
        'userContributions': 0, // TODO: À implémenter avec l'API
        'totalParticipants': 0, // TODO: À implémenter avec l'API
      };
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return {
        'activeTopics': 0,
        'userContributions': 0,
        'totalParticipants': 0,
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
