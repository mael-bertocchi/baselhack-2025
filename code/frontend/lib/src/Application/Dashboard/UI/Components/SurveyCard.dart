import 'package:flutter/material.dart';
import '../../../../theme/AppColors.dart';

/// Modèle de données pour une enquête
class Survey {
  final String? id; // ID optionnel pour l'API
  final String title;
  final String description;
  final String status;
  final String category;
  final int ideasCount;
  final int participantsCount;
  
  // Champs optionnels pour le détail
  final String? createdBy;
  final String? context;
  final List<String>? lookingFor;
  final List<String>? guidelines;
  final String? timeline;

  const Survey({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.ideasCount,
    required this.participantsCount,
    this.createdBy,
    this.context,
    this.lookingFor,
    this.guidelines,
    this.timeline,
  });

  /// Crée une Survey depuis un JSON
  /// Exemple d'utilisation: Survey.fromJson(jsonData)
  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
      category: json['category'] as String? ?? '',
      ideasCount: json['ideasCount'] as int? ?? json['ideas_count'] as int? ?? 0,
      participantsCount: json['participantsCount'] as int? ?? json['participants_count'] as int? ?? 0,
      createdBy: json['createdBy'] as String?,
      context: json['context'] as String?,
      lookingFor: (json['lookingFor'] as List<dynamic>?)?.cast<String>(),
      guidelines: (json['guidelines'] as List<dynamic>?)?.cast<String>(),
      timeline: json['timeline'] as String?,
    );
  }

  /// Convertit une Survey en JSON
  /// Exemple d'utilisation: survey.toJson()
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'status': status,
      'category': category,
      'ideasCount': ideasCount,
      'participantsCount': participantsCount,
      if (createdBy != null) 'createdBy': createdBy,
      if (context != null) 'context': context,
      if (lookingFor != null) 'lookingFor': lookingFor,
      if (guidelines != null) 'guidelines': guidelines,
      if (timeline != null) 'timeline': timeline,
    };
  }

  /// Copie la Survey avec des modifications
  Survey copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? category,
    int? ideasCount,
    int? participantsCount,
    String? createdBy,
    String? context,
    List<String>? lookingFor,
    List<String>? guidelines,
    String? timeline,
  }) {
    return Survey(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      ideasCount: ideasCount ?? this.ideasCount,
      participantsCount: participantsCount ?? this.participantsCount,
      createdBy: createdBy ?? this.createdBy,
      context: context ?? this.context,
      lookingFor: lookingFor ?? this.lookingFor,
      guidelines: guidelines ?? this.guidelines,
      timeline: timeline ?? this.timeline,
    );
  }

  @override
  String toString() {
    return 'Survey(id: $id, title: $title, status: $status, category: $category, ideasCount: $ideasCount, participantsCount: $participantsCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Survey &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.status == status &&
        other.category == category &&
        other.ideasCount == ideasCount &&
        other.participantsCount == participantsCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      status,
      category,
      ideasCount,
      participantsCount,
    );
  }
}

/// Carte d'enquête pour le dashboard
class SurveyCard extends StatefulWidget {
  final Survey survey;
  final VoidCallback? onViewSurvey;

  const SurveyCard({
    super.key,
    required this.survey,
    this.onViewSurvey,
  });

  @override
  State<SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  bool _isHovered = false;

  Color _getStatusColor() {
    switch (widget.survey.status.toLowerCase()) {
      case 'active':
        return const Color(0xFF7C3AED); // Violet
      case 'closed':
        return const Color(0xFF14B8A6); // Cyan/Teal
      case 'soon':
        return const Color(0xFFEC4899); // Rose/Pink
      default:
        return AppColors.blue;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (widget.survey.status.toLowerCase()) {
      case 'active':
        return const Color(0xFFF3E8FF); // Violet clair
      case 'closed':
        return const Color(0xFFCCFBF1); // Cyan très clair
      case 'soon':
        return const Color(0xFFFCE7F3); // Rose clair
      default:
        return AppColors.blueBackground;
    }
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header avec statut et catégorie
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
                      widget.survey.status,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  Text(
                    widget.survey.category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Titre
              Text(
                widget.survey.title,
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

              // Description
              Text(
                widget.survey.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              const SizedBox(height: 20),

              // Stats et bouton
              Row(
                children: [
                  // Nombre d'idées
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.survey.ideasCount} ideas',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Nombre de participants
                  Icon(
                    Icons.people_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.survey.participantsCount} participants',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),

                  // Bouton View Survey
                  ElevatedButton(
                    onPressed: widget.onViewSurvey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueLight, // Teal/Cyan
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
                      'View Survey',
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
