class Idea {
  final String id;
  final String content;
  final String authorId;
  final DateTime createdAt;

  Idea({
    required this.id,
    required this.content,
    required this.authorId,
    required this.createdAt,
  });

  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

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
