import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../theme/AppColors.dart';

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
    );
  }

  /// Vérifie si le topic est actuellement actif
  bool get isActive {
    final now = DateTime.now();
    return status == TopicStatus.open && 
           now.isAfter(startDate) && 
           now.isBefore(endDate);
  }

  /// Retourne le statut sous forme de string pour l'affichage
  String get statusDisplay {
    if (status == TopicStatus.closed || status == TopicStatus.archived) {
      return status.name.capitalize();
    }
    final now = DateTime.now();
    if (now.isBefore(startDate)) {
      return 'Scheduled';
    } else if (now.isAfter(endDate)) {
      return 'Closed';
    }
    return 'Active';
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

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Carte de topic pour le dashboard
class TopicCard extends StatefulWidget {
  final Topic topic;
  final VoidCallback? onViewTopic;

  const TopicCard({
    super.key,
    required this.topic,
    this.onViewTopic,
  });

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  bool _isHovered = false;

  Color _getStatusColor() {
    final displayStatus = widget.topic.statusDisplay.toLowerCase();
    switch (displayStatus) {
      case 'active':
        return const Color(0xFF7C3AED); // Violet
      case 'closed':
        return const Color(0xFF14B8A6); // Cyan/Teal
      case 'scheduled':
        return const Color(0xFFEC4899); // Rose/Pink
      case 'archived':
        return const Color(0xFF6B7280); // Gris
      default:
        return AppColors.blue;
    }
  }

  Color _getStatusBackgroundColor() {
    final displayStatus = widget.topic.statusDisplay.toLowerCase();
    switch (displayStatus) {
      case 'active':
        return const Color(0xFFF3E8FF); // Violet clair
      case 'closed':
        return const Color(0xFFCCFBF1); // Cyan très clair
      case 'scheduled':
        return const Color(0xFFFCE7F3); // Rose clair
      case 'archived':
        return const Color(0xFFF3F4F6); // Gris clair
      default:
        return AppColors.blueBackground;
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.topic.statusDisplay,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  // Afficher les dates
                  Text(
                    'Until ${_formatDate(widget.topic.endDate)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Titre
              Text(
                widget.topic.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Short Description with Markdown support
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        ClipRect(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: constraints.maxHeight,
                            ),
                            child: OverflowBox(
                              maxHeight: double.infinity,
                              alignment: Alignment.topLeft,
                              child: MarkdownBody(
                                data: widget.topic.shortDescription,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                  strong: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  em: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary,
                                  ),
                                  code: TextStyle(
                                    fontSize: 13,
                                    backgroundColor: AppColors.background,
                                    color: AppColors.blue,
                                    fontFamily: 'monospace',
                                  ),
                                  a: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                shrinkWrap: true,
                                softLineBreak: true,
                              ),
                            ),
                          ),
                        ),
                        // Fade out gradient at the bottom
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Footer avec auteur et bouton
              Row(
                children: [
                  // Auteur
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'By ${widget.topic.authorId}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Bouton View Topic
                  ElevatedButton(
                    onPressed: widget.onViewTopic,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueLight,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View Topic',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
