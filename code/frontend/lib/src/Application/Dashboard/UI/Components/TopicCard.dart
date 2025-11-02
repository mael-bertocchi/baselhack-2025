import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../theme/AppColors.dart';
import 'package:alignify/l10n/app_localizations.dart';
import 'package:alignify/src/Application/Shared/Models/Models.dart';

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
  final VoidCallback? onEditTopic;
  final VoidCallback? onDeleteTopic;
  final bool showActions;

  const TopicCard({
    super.key,
    required this.topic,
    this.onViewTopic,
    this.onEditTopic,
    this.onDeleteTopic,
    this.showActions = false,
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

  String _getStatusDisplayText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Utilise directement le statut défini
    switch (widget.topic.status) {
      case TopicStatus.open:
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final start = DateTime(widget.topic.startDate.year, widget.topic.startDate.month, widget.topic.startDate.day);
        final end = DateTime(widget.topic.endDate.year, widget.topic.endDate.month, widget.topic.endDate.day);
        
        // Si la date de début n'est pas encore arrivée
        if (today.isBefore(start)) {
          return l10n.scheduled;
        }
        // Si la date de fin est dépassée
        if (today.isAfter(end)) {
          return l10n.closed;
        }
        return l10n.active;
      case TopicStatus.closed:
        return l10n.closed;
      case TopicStatus.archived:
        return l10n.archived;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  Row(
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
                          _getStatusDisplayText(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(),
                          ),
                        ),
                      ),
                      // AI Result Badge
                      if (widget.topic.hasAiResult) ...[
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 13,
                              color: AppColors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'AI',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  // Afficher les dates
                  Text(
                    '${l10n.until} ${_formatDate(widget.topic.endDate)}',
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

              // // Long Description
              // Text(
              //   widget.topic.description,
              //   style: const TextStyle(
              //     fontSize: 14,
              //     color: AppColors.textSecondary,
              //     height: 1.6,
              //   ),
              //   maxLines: 5,
              //   overflow: TextOverflow.ellipsis,
              // ),
              // const Spacer(),
              // const SizedBox(height: 20),

              // Footer avec auteur et bouton
              Row(
                children: [
                  // Nombre de soumissions
                  if (widget.topic.nbSubmissions != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 16,
                            color: AppColors.blue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.topic.nbSubmissions}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  
                  // Auteur
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context)!.by} ${widget.topic.authorId}',
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

                  // Action buttons for managers/admins
                  if (widget.showActions) ...[
                    // Edit button
                    IconButton(
                      onPressed: widget.onEditTopic,
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: 20,
                      color: AppColors.blue,
                      tooltip: 'Edit Topic',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.blueBackground,
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(36, 36),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Delete button
                    IconButton(
                      onPressed: widget.onDeleteTopic,
                      icon: const Icon(Icons.delete_outline),
                      iconSize: 20,
                      color: AppColors.pink,
                      tooltip: 'Delete Topic',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.pink.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(36, 36),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

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
