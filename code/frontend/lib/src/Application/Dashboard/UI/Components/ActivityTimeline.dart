import 'package:flutter/material.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../../theme/AppColors.dart';
import '../../../Shared/Models/Models.dart';

class ActivityTimeline extends StatelessWidget {
  final List<Topic> topics;

  const ActivityTimeline({
    super.key,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Activity Alerts: New Topics --> amount of topics (all kind) that have createdAt in the last week
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    final newTopics = topics.where((t) {
      return t.createdAt.isAfter(oneWeekAgo);
    }).length;
    
    // Activity Alerts: Closing Soon --> amount of "Active" topics that end in less than 3 days
    final threeDaysFromNow = now.add(const Duration(days: 3));
    final closingSoon = topics.where((t) {
      return t.statusDisplay == 'Active' && 
             t.endDate.isAfter(now) && 
             t.endDate.isBefore(threeDaysFromNow);
    }).length;
    
    // Activity Alerts: Needs Attention --> topics that have at least 50% less attention than the median,
    // and that are at least 30% of their lifetime
    final needsAttention = _calculateNeedsAttention(topics);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: AppColors.pink,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.activityAlerts,
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
          l10n.importantUpdatesNotifications,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        // Alert Cards
        _buildAlertCard(
          Icons.fiber_new,
          l10n.newTopics,
          l10n.createdThisWeek(newTopics),
          const Color(0xFF10B981),
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          Icons.access_time,
          l10n.closingSoon,
          l10n.topicsEndingInDays(closingSoon),
          const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          Icons.warning_amber_rounded,
          l10n.needsAttention,
          l10n.topicsLowEngagement(needsAttention),
          const Color(0xFFEF4444),
        ),
      ],
    );
  }

  Widget _buildAlertCard(
    IconData icon,
    String title,
    String description,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Calculate topics that need attention:
  /// Topics that have at least 50% less attention than the median,
  /// and that are at least 30% of their lifetime
  int _calculateNeedsAttention(List<Topic> topics) {
    final now = DateTime.now();
    
    // Filter only active topics
    final activeTopics = topics.where((t) => t.statusDisplay == 'Active').toList();
    
    if (activeTopics.isEmpty) return 0;
    
    // Calculate median number of submissions
    final submissionCounts = activeTopics
        .map((t) => t.nbSubmissions ?? 0)
        .toList()
      ..sort();
    
    final median = submissionCounts.isEmpty 
        ? 0.0 
        : submissionCounts.length.isOdd
            ? submissionCounts[submissionCounts.length ~/ 2].toDouble()
            : (submissionCounts[submissionCounts.length ~/ 2 - 1] + 
               submissionCounts[submissionCounts.length ~/ 2]) / 2.0;
    
    // Threshold: 50% less than median
    final attentionThreshold = median * 0.5;
    
    // Count topics that need attention
    int count = 0;
    for (final topic in activeTopics) {
      final submissions = topic.nbSubmissions ?? 0;
      
      // Check if submissions are at least 50% less than median
      if (submissions < attentionThreshold) {
        // Check if topic is at least 30% through its lifetime
        final totalDuration = topic.endDate.difference(topic.startDate).inDays;
        final elapsedDuration = now.difference(topic.startDate).inDays;
        
        if (totalDuration > 0) {
          final lifetimeProgress = elapsedDuration / totalDuration;
          
          // If at least 30% of lifetime has passed
          if (lifetimeProgress >= 0.3) {
            count++;
          }
        }
      }
    }
    
    return count;
  }
}
