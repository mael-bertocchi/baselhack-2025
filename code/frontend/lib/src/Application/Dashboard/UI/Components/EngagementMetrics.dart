import 'package:flutter/material.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../../theme/AppColors.dart';
import '../../../Shared/Models/Models.dart';

class EngagementMetrics extends StatelessWidget {
  final List<Topic> topics;
  final int totalSubmissions;
  final int totalUsers;

  const EngagementMetrics({
    super.key,
    required this.topics,
    required this.totalSubmissions,
    required this.totalUsers,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Calculate metrics
    final avgSubmissionsPerTopic = topics.isEmpty ? 0.0 : totalSubmissions / topics.length;
    
    // AI Summary Coverage: percentage of "Active" topics that have an AI result text
    final activeTopics = topics.where((t) => t.statusDisplay == 'Active').toList();
    final activeTopicsWithAiResult = activeTopics.where((t) => t.hasAiResult).length;
    final aiSummaryCoverage = activeTopics.isEmpty ? 0.0 : (activeTopicsWithAiResult / activeTopics.length);
    
    // Pending Summary: Amount of remaining "Active" topics that don't have an AI result text
    final pendingSummary = activeTopics.where((t) => !t.hasAiResult).length;
    
    // Topic Participation: percentage of topics (any status) that have at least one submission
    final topicsWithSubmissions = topics.where((t) => (t.nbSubmissions ?? 0) > 0).length;
    final topicParticipation = topics.isEmpty ? 0.0 : (topicsWithSubmissions / topics.length);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: AppColors.blue,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.engagementOverview,
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
          l10n.platformActivityMetrics,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        // Metrics Grid
        Row(
          children: [
            // Circular Progress - AI Summary Coverage
            Expanded(
              child: _buildCircularMetric(
                context,
                l10n.aiSummaryCoverage,
                aiSummaryCoverage,
                '${(aiSummaryCoverage * 100).toStringAsFixed(0)}%',
                Icons.auto_awesome,
                AppColors.pink,
              ),
            ),
            const SizedBox(width: 16),
            // Circular Progress - Topic Participation
            Expanded(
              child: _buildCircularMetric(
                context,
                l10n.topicParticipation,
                topicParticipation,
                '${(topicParticipation * 100).toStringAsFixed(0)}%',
                Icons.groups,
                AppColors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Bottom Stats
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                Icons.pending_actions,
                l10n.pendingSummary,
                pendingSummary.toString(),
                const Color(0xFFF59E0B),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: const Color(0xFFE5E7EB),
            ),
            Expanded(
              child: _buildStatItem(
                Icons.chat_bubble_outline,
                l10n.avgPerTopic,
                avgSubmissionsPerTopic.toStringAsFixed(1),
                AppColors.pink,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularMetric(
    BuildContext context,
    String label,
    double value,
    String displayValue,
    IconData icon,
    Color color,
  ) {
    final clampedValue = value.clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 6,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color.withOpacity(0.1),
                    ),
                  ),
                ),
                // Progress circle
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: clampedValue,
                    strokeWidth: 6,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                // Center icon and value
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(height: 2),
                    Text(
                      displayValue,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
