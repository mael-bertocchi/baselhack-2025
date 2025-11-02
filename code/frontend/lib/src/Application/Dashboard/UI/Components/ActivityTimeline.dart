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
    
    // Calculate recent activity (last 7 days simulation)
    final recentTopics = topics.where((t) {
      final now = DateTime.now();
      final daysDiff = now.difference(t.createdAt).inDays;
      return daysDiff <= 7;
    }).length;
    
    final closingSoon = topics.where((t) {
      final now = DateTime.now();
      final daysUntilEnd = t.endDate.difference(now).inDays;
      return daysUntilEnd >= 0 && daysUntilEnd <= 3 && t.statusDisplay == 'Active';
    }).length;
    
    final needsAttention = topics.where((t) {
      return t.statusDisplay == 'Active' && (t.nbSubmissions ?? 0) < 3;
    }).length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(
              Icons.notifications_active,
              color: AppColors.pink,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.activityAlerts,
              style: const TextStyle(
                fontSize: 16,
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
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        
        // Alert Cards
        _buildAlertCard(
          Icons.fiber_new,
          l10n.newTopics,
          l10n.createdThisWeek(recentTopics),
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
}
