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

  const Survey({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.ideasCount,
    required this.participantsCount,
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
  }) {
    return Survey(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      ideasCount: ideasCount ?? this.ideasCount,
      participantsCount: participantsCount ?? this.participantsCount,
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
        return AppColors.blue;
      case 'closed':
        return AppColors.textSecondary;
      case 'soon':
        return AppColors.warning;
      default:
        return AppColors.warning;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (widget.survey.status.toLowerCase()) {
      case 'active':
        return AppColors.blueBackground;
      case 'closed':
        return AppColors.background;
      case 'soon':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFFEF3C7);
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.05),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 8 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: SelectableText(
                    widget.survey.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
                SelectableText(
                  widget.survey.category,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Titre
            SelectableText(
              widget.survey.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            SelectableText(
              widget.survey.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Stats et bouton
            Row(
              children: [
                // Nombre d'idées
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                SelectableText(
                  '${widget.survey.ideasCount} ideas',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 20),

                // Nombre de participants
                const Icon(
                  Icons.people_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                SelectableText(
                  '${widget.survey.participantsCount} participants',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),

                // Bouton View Survey
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: widget.onViewSurvey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
