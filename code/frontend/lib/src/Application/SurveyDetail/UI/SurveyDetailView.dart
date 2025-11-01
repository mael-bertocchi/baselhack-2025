import 'package:flutter/material.dart';
import '../../../theme/AppColors.dart';
import '../../Dashboard/UI/Components/TopicCard.dart';
import '../Models/Idea.dart';

// Alias temporaire pour rétrocompatibilité
typedef Survey = Topic;

class SurveyDetailView extends StatefulWidget {
  final Survey survey;

  const SurveyDetailView({
    super.key,
    required this.survey,
  });

  @override
  State<SurveyDetailView> createState() => _SurveyDetailViewState();
}

class _SurveyDetailViewState extends State<SurveyDetailView> {
  final TextEditingController _ideaController = TextEditingController();
  final List<Idea> _ideas = [
    // Mock data
    Idea(
      id: '1',
      content: 'We should implement a transparent voting system where everyone can see the results in real-time.',
      authorId: 'john_doe',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Idea(
      id: '2',
      content: 'Creating a mobile app would make it easier for citizens to participate in consultations.',
      authorId: 'jane_smith',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Idea(
      id: '3',
      content: 'Regular town hall meetings could complement the digital platform for those who prefer in-person discussions.',
      authorId: 'mark_wilson',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  void dispose() {
    _ideaController.dispose();
    super.dispose();
  }

  void _submitIdea() {
    if (_ideaController.text.trim().isEmpty) return;

    setState(() {
      _ideas.insert(
        0,
        Idea(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _ideaController.text.trim(),
          authorId: 'current_user',
          createdAt: DateTime.now(),
        ),
      );
      _ideaController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Idea submitted successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF14B8A6),
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Color _getStatusColor() {
    final displayStatus = widget.survey.statusDisplay.toLowerCase();
    switch (displayStatus) {
      case 'active':
        return const Color(0xFF0891B2); // Cyan
      case 'closed':
        return const Color(0xFF14B8A6);
      case 'scheduled':
        return const Color(0xFFEC4899);
      case 'archived':
        return const Color(0xFF6B7280);
      default:
        return AppColors.blue;
    }
  }

  Color _getStatusBackgroundColor() {
    final displayStatus = widget.survey.statusDisplay.toLowerCase();
    switch (displayStatus) {
      case 'active':
        return const Color(0xFFCFFAFE); // Cyan très clair
      case 'closed':
        return const Color(0xFFCCFBF1);
      case 'scheduled':
        return const Color(0xFFFCE7F3);
      case 'archived':
        return const Color(0xFFF3F4F6);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'C',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Consensus Hub',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(Icons.person, color: AppColors.textSecondary),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton Back to Surveys
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.arrow_back,
                      color: AppColors.blue,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Back to Surveys',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Badge de statut
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
                  '${widget.survey.statusDisplay} Topic',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Titre
              Text(
                widget.survey.title,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                widget.survey.description,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // Info ligne avec dates et auteur
              Text(
                'Created by: ${widget.survey.authorId} • From ${_formatDate(widget.survey.startDate)} to ${_formatDate(widget.survey.endDate)} • Last updated ${_formatDate(widget.survey.updatedAt)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // Carte Survey Overview
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bordure cyan à gauche
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 4,
                            height: 600,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0891B2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Topic Overview',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Short Description
                                const Text(
                                  'Summary',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.survey.shortDescription,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Full Description
                                const Text(
                                  'Detailed Description',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.survey.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Timeline
                                const Text(
                                  'Timeline',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildTimelineItem(
                                  'Topic Opens',
                                  _formatDate(widget.survey.startDate),
                                  Icons.play_circle_outline,
                                ),
                                const SizedBox(height: 8),
                                _buildTimelineItem(
                                  'Topic Closes',
                                  _formatDate(widget.survey.endDate),
                                  Icons.check_circle_outline,
                                ),
                                const SizedBox(height: 8),
                                _buildTimelineItem(
                                  'Created',
                                  _formatDate(widget.survey.createdAt),
                                  Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Section Share Your Idea
              if (widget.survey.isActive) ...[
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF14B8A6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF14B8A6).withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Share Your Idea',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'All submissions are anonymous - your perspective matters!',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Your Idea',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _ideaController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Share your thoughts, ideas, or concerns... (Be specific and constructive)',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF14B8A6),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'You can submit multiple ideas. All submissions are anonymous.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          onPressed: _submitIdea,
                          icon: const Icon(Icons.send, size: 18),
                          label: const Text(
                            'Submit Idea',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],

              // Section All Ideas
              Row(
                children: [
                  const Text(
                    'All Ideas',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_ideas.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Liste des idées
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ideas.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final idea = _ideas[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contenu de l'idée
                        Text(
                          idea.content,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Footer avec date
                        Text(
                          _getTimeAgo(idea.createdAt),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String label, String date, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.blue,
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          date,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}