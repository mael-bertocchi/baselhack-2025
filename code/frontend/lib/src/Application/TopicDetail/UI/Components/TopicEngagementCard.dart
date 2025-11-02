import 'package:flutter/material.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../../theme/AppColors.dart';
import '../../../Shared/Models/Models.dart';

class TopicEngagementCard extends StatelessWidget {
  final Topic topic;
  final int totalSubmissions;
  final bool hasAiSummary;

  const TopicEngagementCard({
    super.key,
    required this.topic,
    required this.totalSubmissions,
    required this.hasAiSummary,
  });

  int _getDaysActive() {
    final now = DateTime.now();
    final start = topic.startDate;
    
    if (now.isBefore(start)) {
      return 0;
    }
    
    final end = topic.endDate;
    final actualEnd = now.isAfter(end) ? end : now;
    
    return actualEnd.difference(start).inDays + 1;
  }

  int _getTotalDuration() {
    return topic.endDate.difference(topic.startDate).inDays + 1;
  }

  double _getCompletionPercentage() {
    final totalDays = _getTotalDuration();
    final activeDays = _getDaysActive();
    
    if (totalDays <= 0) return 0.0;
    
    return (activeDays / totalDays).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final completionPercentage = _getCompletionPercentage();
    final daysActive = _getDaysActive();
    final totalDays = _getTotalDuration();
    final avgSubmissionsPerDay = daysActive > 0 ? (totalSubmissions / daysActive).toStringAsFixed(1) : '0.0';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Icon(
              Icons.assessment_outlined,
              color: AppColors.blue,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.engagementOverviewTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.keyMetricsForTopic,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        // Metrics grid
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: l10n.totalSubmissions,
                value: totalSubmissions.toString(),
                icon: Icons.chat_bubble_outline,
                color: AppColors.blue,
                context: context,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                label: l10n.avgPerDay,
                value: avgSubmissionsPerDay,
                icon: Icons.trending_up,
                color: const Color(0xFF7C3AED),
                context: context,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: l10n.daysActive,
                value: '$daysActive / $totalDays',
                icon: Icons.calendar_today,
                color: AppColors.pink,
                context: context,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                label: l10n.aiAnalysis,
                value: hasAiSummary ? l10n.complete : l10n.pending,
                icon: hasAiSummary ? Icons.check_circle : Icons.schedule,
                color: hasAiSummary ? const Color(0xFF14B8A6) : const Color(0xFFF59E0B),
                context: context,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Progress bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.topicProgress,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${(completionPercentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: completionPercentage,
                minHeight: 12,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation<Color>(
                  completionPercentage >= 1.0 
                    ? const Color(0xFF14B8A6) 
                    : AppColors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              completionPercentage >= 1.0 
                ? l10n.topicPeriodEnded
                : l10n.daysElapsed(daysActive, totalDays),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
