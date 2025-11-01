import 'package:frontend/src/Application/Dashboard/UI/Components/TopicCard.dart';

/// Service pour gérer les appels API du dashboard
/// 
/// TODO: Remplacer les méthodes mockées par de vrais appels HTTP
/// Exemple avec package:http ou package:dio
class DashboardApiService {
  // Singleton pattern
  static final DashboardApiService _instance = DashboardApiService._internal();
  factory DashboardApiService() => _instance;
  DashboardApiService._internal();

  // TODO: Ajouter votre base URL API
  // static const String baseUrl = 'https://api.example.com'\;

  /// Récupère la liste des topics
  /// 
  /// Exemple d'implémentation avec HTTP:
  /// ```dart
  /// Future<List<Topic>> getTopics() async {
  ///   final response = await http.get(Uri.parse('$baseUrl/topics'));
  ///   if (response.statusCode == 200) {
  ///     final List<dynamic> data = json.decode(response.body);
  ///     return data.map((json) => Topic.fromJson(json)).toList();
  ///   }
  ///   throw Exception('Failed to load topics');
  /// }
  /// ```
  Future<List<Topic>> getTopics() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    // TODO: Remplacer par un vrai appel API
    return [
      Topic(
        title: 'Digital Transformation Strategy',
        shortDescription: 'How should we prioritize digital initiatives across the organization?',
        description: 'Our organization is at a critical juncture in our digital journey. We need diverse perspectives from team members across all departments to make informed decisions about our digital transformation priorities.',
        startDate: DateTime(2025, 11, 1),
        endDate: DateTime(2025, 12, 15),
        createdAt: DateTime(2025, 10, 25),
        updatedAt: DateTime(2025, 10, 25),
        status: TopicStatus.open,
        authorId: 'Michael Chen',
      ),
      Topic(
        title: 'Workplace Flexibility',
        shortDescription: 'What flexible work arrangements would improve productivity?',
        description: 'As we evolve our workplace policies, we want to understand what flexibility options would best support our team\047s productivity and work-life balance.',
        startDate: DateTime(2025, 12, 1),
        endDate: DateTime(2026, 1, 15),
        createdAt: DateTime(2025, 11, 1),
        updatedAt: DateTime(2025, 11, 1),
        status: TopicStatus.open,
        authorId: 'Sarah Johnson',
      ),
      Topic(
        title: 'Product Innovation',
        shortDescription: 'What new features should we develop for our next product release?',
        description: 'We\047re planning our Q2 2026 product roadmap and need input on features that will deliver the most value to our customers.',
        startDate: DateTime(2025, 11, 1),
        endDate: DateTime(2025, 12, 20),
        createdAt: DateTime(2025, 10, 28),
        updatedAt: DateTime(2025, 10, 28),
        status: TopicStatus.open,
        authorId: 'Alex Rodriguez',
      ),
      Topic(
        title: 'Sustainability Goals',
        shortDescription: 'How can we reduce our environmental impact?',
        description: 'We are committed to reducing our carbon footprint and need innovative ideas from the team.',
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2025, 10, 31),
        createdAt: DateTime(2025, 8, 25),
        updatedAt: DateTime(2025, 8, 25),
        status: TopicStatus.closed,
        authorId: 'Emma Wilson',
      ),
      Topic(
        title: 'Customer Experience',
        shortDescription: 'What improvements would enhance customer satisfaction?',
        description: 'We want to understand pain points and opportunities to improve our customer experience.',
        startDate: DateTime(2025, 11, 1),
        endDate: DateTime(2026, 1, 31),
        createdAt: DateTime(2025, 10, 30),
        updatedAt: DateTime(2025, 10, 30),
        status: TopicStatus.open,
        authorId: 'James Lee',
      ),
      Topic(
        title: 'Team Collaboration Tools',
        shortDescription: 'Which tools would best support our team collaboration?',
        description: 'Evaluation of collaboration tools to enhance team productivity and communication.',
        startDate: DateTime(2025, 11, 5),
        endDate: DateTime(2025, 12, 31),
        createdAt: DateTime(2025, 11, 1),
        updatedAt: DateTime(2025, 11, 1),
        status: TopicStatus.open,
        authorId: 'Lisa Martinez',
      ),
    ];
  }

  /// Récupère les statistiques du dashboard
  Future<Map<String, int>> getDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return {
      'activeTopics': 5,
      'userContributions': 12,
      'totalParticipants': 847,
    };
  }

  /// Récupère un topic spécifique par son ID
  Future<Topic?> getTopicById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
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
}
