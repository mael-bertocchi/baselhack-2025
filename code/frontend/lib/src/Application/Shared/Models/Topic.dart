/// Type représentant le statut d'un topic
enum TopicStatus {
  open,
  closed,
  archived;

  String toJson() => name;

  static TopicStatus fromJson(String value) {
    switch (value.toLowerCase()) {
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

/// Modèle de données pour un topic de discussion
class Topic {
  final String? id; // ID optionnel pour l'API
  final String title;
  final String shortDescription;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TopicStatus status;
  final String authorId;
  final int? nbSubmissions; // Nombre de soumissions
  final bool hasAiResult; // Indique si le topic a un résultat AI

  const Topic({
    this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.authorId,
    this.nbSubmissions,
    this.hasAiResult = false,
  });

  /// Crée un Topic depuis un JSON
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startDate: DateTime.parse(json['startDate'] as String? ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] as String? ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
      status: TopicStatus.fromJson(json['status'] as String? ?? 'open'),
      authorId: json['authorId'] as String? ?? '',
      nbSubmissions: json['nbSubmissions'] as int?,
      hasAiResult: json['hasAiResult'] as bool? ?? false,
    );
  }

  /// Convertit un Topic en JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'short_description': shortDescription,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.toJson(),
      'authorId': authorId,
      if (nbSubmissions != null) 'nbSubmissions': nbSubmissions,
    };
  }

  /// Copie le Topic avec des modifications
  Topic copyWith({
    String? id,
    String? title,
    String? shortDescription,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    TopicStatus? status,
    String? authorId,
    int? nbSubmissions,
    bool? hasAiResult,
  }) {
    return Topic(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      authorId: authorId ?? this.authorId,
      nbSubmissions: nbSubmissions ?? this.nbSubmissions,
      hasAiResult: hasAiResult ?? this.hasAiResult,
    );
  }

  /// Vérifie si le topic est actuellement actif
  bool get isActive {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    
    return status == TopicStatus.open && 
           (today.isAfter(start) || today.isAtSameMomentAs(start)) && 
           (today.isBefore(end) || today.isAtSameMomentAs(end));
  }

  /// Retourne le statut sous forme de string pour l'affichage
  String get statusDisplay {
    // Utilise directement le statut défini
    switch (status) {
      case TopicStatus.open:
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final start = DateTime(startDate.year, startDate.month, startDate.day);
        final end = DateTime(endDate.year, endDate.month, endDate.day);
        
        // Si la date de début n'est pas encore arrivée
        if (today.isBefore(start)) {
          return 'Scheduled';
        }
        // Si la date de fin est dépassée
        if (today.isAfter(end)) {
          return 'Closed';
        }
        return 'Active';
      case TopicStatus.closed:
        return 'Closed';
      case TopicStatus.archived:
        return 'Archived';
    }
  }

  @override
  String toString() {
    return 'Topic(id: $id, title: $title, status: $status, authorId: $authorId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Topic &&
        other.id == id &&
        other.title == title &&
        other.shortDescription == shortDescription &&
        other.status == status &&
        other.authorId == authorId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      shortDescription,
      status,
      authorId,
    );
  }
}
