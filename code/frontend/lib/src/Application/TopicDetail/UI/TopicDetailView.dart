import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../theme/AppColors.dart';
import '../../../widgets/SharedAppBar.dart';
import 'package:alignify/src/Application/Shared/Models/Models.dart';
import 'package:alignify/src/Application/Shared/Api/TopicService.dart';
import 'package:alignify/src/Application/Shared/Api/AuthService.dart';
import '../../../routes/AppRoutes.dart';

// Alias temporaire pour rétrocompatibilité
typedef Survey = Topic;

class TopicDetailView extends StatefulWidget {
  final String topicId;

  const TopicDetailView({
    super.key,
    required this.topicId,
  });

  @override
  State<TopicDetailView> createState() => TopicDetailViewState();
}

class TopicDetailViewState extends State<TopicDetailView> {
  final TextEditingController _ideaController = TextEditingController();
  final TopicService _topicService = TopicService();
  
  Topic? _topic;
  List<Idea> _ideas = [];
  TopicResult? _aiSummary;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isAnalyzing = false;
  String? _error;
  
  static const int maxIdeaLength = 1000;

  @override
  void initState() {
    super.initState();
    _loadTopicAndSubmissions();
  }

  /// Charge le topic et ses soumissions depuis l'API
  Future<void> _loadTopicAndSubmissions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load topic data first
      final topic = await _topicService.getTopicById(widget.topicId);
      
      if (topic == null) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _error = l10n.topicNotFound;
          _isLoading = false;
        });
        return;
      }
      
      // Load submissions and AI summary in parallel
      final results = await Future.wait([
        _topicService.getSubmissions(widget.topicId),
        _topicService.getTopicResult(widget.topicId).catchError((_) => null),
      ]);
      
      setState(() {
        _topic = topic;
        _ideas = results[0] as List<Idea>;
        _aiSummary = results[1] as TopicResult?;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.failedToLoadTopic(e.toString());
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error!),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _ideaController.dispose();
    super.dispose();
  }

  /// Check if current user can edit this topic
  bool _canEditTopic() {
    final currentUser = AuthService.instance.currentUser;
    return currentUser?.role == Role.administrator || 
           currentUser?.role == Role.manager;
  }

  /// Navigate to edit topic page
  void _navigateToEditTopic() {
    if (_topic?.id != null) {
      Navigator.of(context)
          .pushNamed('/topics/${_topic!.id}/edit')
          .then((_) => _loadTopicAndSubmissions()); // Reload topic after edit
    }
  }

  Future<void> _triggerAIAnalysis() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = await _topicService.analyzeTopic(widget.topicId);

      setState(() {
        _aiSummary = result;
        _isAnalyzing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI analysis completed successfully!'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF14B8A6),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to analyze topic: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _submitIdea() async {
    if (_ideaController.text.trim().isEmpty) return;
    if (_topic == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final newIdea = await _topicService.submitIdea(
        widget.topicId,
        _ideaController.text.trim(),
      );

      setState(() {
        _ideas.insert(0, newIdea);
        _ideaController.clear();
        _isSubmitting = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.ideaSubmittedSuccessfully),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF14B8A6),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToSubmitIdea(e.toString())),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
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
    if (_topic == null) return AppColors.blue;
    final displayStatus = _topic!.statusDisplay.toLowerCase();
    switch (displayStatus) {
      case 'active':
        return const Color(0xFF7C3AED);
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
    if (_topic == null) return AppColors.blueBackground;
    final displayStatus = _topic!.statusDisplay.toLowerCase();
    switch (displayStatus) {
      case 'active':
        return const Color.fromARGB(255, 242, 234, 255); // Cyan très clair
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SharedAppBar(
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.blueLight),
              ),
            )
          : _error != null && _topic == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Color(0xFFEF4444),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.errorLoadingTopic,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadTopicAndSubmissions,
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.tryAgain),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final horizontalPadding = isMobile ? 16.0 : constraints.maxWidth * 0.1;
            return Padding(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: 32.0,
                bottom: 32.0,
              ),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back button and Edit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton Back to Surveys
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.dashboard,
                        (route) => false,
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          color: AppColors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.backToSurveys,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Edit button for admins and managers
                  if (_canEditTopic())
                    ElevatedButton.icon(
                      onPressed: () => _navigateToEditTopic(),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(l10n.editTopic),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),

              // Info ligne avec dates et auteur
              SelectableText(
                '${l10n.createdBy}: ${_topic!.authorId} • ${l10n.from} ${_formatDate(_topic!.startDate)} ${l10n.to} ${_formatDate(_topic!.endDate)} • ${l10n.lastUpdated} ${_formatDate(_topic!.updatedAt)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

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
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 4,
                              decoration: BoxDecoration(
                                color: AppColors.blueLight,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                  '${_topic!.statusDisplay} Topic',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
                                SelectableText(
                                  _topic!.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 22),

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
                                MarkdownBody(
                                  data: _topic!.shortDescription,
                                  selectable: true,
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                    strong: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                    em: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textSecondary,
                                    ),
                                    code: TextStyle(
                                      fontSize: 15,
                                      backgroundColor: AppColors.background,
                                      color: AppColors.blue,
                                      fontFamily: 'monospace',
                                    ),
                                    codeblockDecoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    blockquote: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    blockquoteDecoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(4),
                                      border: const Border(
                                        left: BorderSide(
                                          color: AppColors.blue,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                    a: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    h1: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                    h2: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                    h3: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    listBullet: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Full Description
                                Text(
                                  l10n.detailedDescription,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                MarkdownBody(
                                  data: _topic!.description,
                                  selectable: true,
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                    strong: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                    em: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textSecondary,
                                    ),
                                    code: TextStyle(
                                      fontSize: 15,
                                      backgroundColor: AppColors.background,
                                      color: AppColors.blue,
                                      fontFamily: 'monospace',
                                    ),
                                    codeblockDecoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    blockquote: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    blockquoteDecoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(4),
                                      border: const Border(
                                        left: BorderSide(
                                          color: AppColors.blue,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                    a: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    h1: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                    h2: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                    h3: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    listBullet: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Timeline
                                Text(
                                  l10n.timeline,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildTimelineItem(
                                  l10n.topicOpens,
                                  _formatDate(_topic!.startDate),
                                  Icons.play_circle_outline,
                                ),
                                const SizedBox(height: 8),
                                _buildTimelineItem(
                                  l10n.topicCloses,
                                  _formatDate(_topic!.endDate),
                                  Icons.check_circle_outline,
                                ),
                                const SizedBox(height: 8),
                                _buildTimelineItem(
                                  l10n.created,
                                  _formatDate(_topic!.createdAt),
                                  Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // AI-Generated Summary Card
              if (_aiSummary != null)
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF0F9FF),
                        Color(0xFFE0F2FE),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.blue.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: AppColors.blue,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI-Generated Summary',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Automated analysis of all submitted ideas and patterns',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Color(0xFFBFDBFE)),
                        const SizedBox(height: 24),
                        MarkdownBody(
                          data: _aiSummary!.content,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                            strong: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            h1: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            h2: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            h3: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            listBullet: const TextStyle(
                              fontSize: 16,
                              color: AppColors.blue,
                            ),
                            blockquote: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            blockquoteDecoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                              border: const Border(
                                left: BorderSide(
                                  color: AppColors.blue,
                                  width: 4,
                                ),
                              ),
                            ),
                            code: TextStyle(
                              fontSize: 15,
                              backgroundColor: Colors.white.withValues(alpha: 0.7),
                              color: AppColors.blue,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 18,
                                color: AppColors.blue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Last updated: ${_formatDate(_aiSummary!.updatedAt)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_aiSummary != null) const SizedBox(height: 40),

              // Section Share Your Idea
              if (_topic!.isActive) ...[
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.blueLight,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blueLight,
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.shareYourIdea,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.anonymousSubmissions,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        l10n.yourIdea,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _ideaController,
                        maxLines: 5,
                        maxLength: maxIdeaLength,
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                          return Text(
                            '$currentLength/$maxIdeaLength',
                            style: TextStyle(
                              fontSize: 12,
                              color: currentLength > maxIdeaLength * 0.9 
                                  ? const Color(0xFFEF4444) 
                                  : AppColors.textSecondary,
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: l10n.ideaPlaceholder,
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
                              color: AppColors.blueLight,
                              width: 1,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.multipleSubmissionsNote,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : _submitIdea,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                  ),
                                )
                              : const Icon(Icons.send, size: 18),
                          label: Text(
                            _isSubmitting ? l10n.submitting : l10n.submitIdea,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSubmitting 
                                ? AppColors.blueLight.withValues(alpha: 0.6)
                                : AppColors.blueLight,
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
                  Text(
                    l10n.allIdeas,
                    style: const TextStyle(
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
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.blueLight),
                    ),
                  ),
                )
              else if (_error != null && _ideas.isEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFEF4444),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _loadTopicAndSubmissions,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              else if (_ideas.isEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noIdeasYet,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.beFirstToShare,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
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
                          SelectableText(
                            idea.content,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Footer avec date
                          SelectableText(
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
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
    final currentUser = AuthService.instance.currentUser;
    final isAdminOrManager = currentUser?.role == Role.administrator || 
                              currentUser?.role == Role.manager;
    
    if (!isAdminOrManager || _topic == null) {
      return null;
    }

    final l10n = AppLocalizations.of(context)!;
    final hasIdeas = _ideas.isNotEmpty;
    final isDisabled = _isAnalyzing || !hasIdeas;

    return FloatingActionButton.extended(
      onPressed: isDisabled ? null : _triggerAIAnalysis,
      backgroundColor: isDisabled ? AppColors.textSecondary : AppColors.blue,
      foregroundColor: AppColors.white,
      icon: _isAnalyzing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
          : const Icon(Icons.auto_awesome),
      label: Text(_isAnalyzing 
          ? l10n.analyzing 
          : hasIdeas 
              ? l10n.generateAiSummary 
              : l10n.noIdeasToAnalyze),
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
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextSpan(
                text: date,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}