import 'package:flutter/material.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../../theme/AppColors.dart';
import '../../../Shared/Models/Models.dart';

class ParticipationInsights extends StatelessWidget {
  final Topic topic;
  final List<Idea> submissions;

  const ParticipationInsights({
    super.key,
    required this.topic,
    required this.submissions,
  });

  Map<int, int> _getHourlyDistribution() {
    final Map<int, int> hourly = {};
    
    for (int i = 0; i < 24; i++) {
      hourly[i] = 0;
    }
    
    for (final submission in submissions) {
      final hour = submission.createdAt.hour;
      hourly[hour] = (hourly[hour] ?? 0) + 1;
    }
    
    return hourly;
  }

  String _getMostActiveHour() {
    if (submissions.isEmpty) return 'N/A';
    
    final hourly = _getHourlyDistribution();
    final maxHour = hourly.entries.reduce((a, b) => a.value > b.value ? a : b);
    
    if (maxHour.value == 0) return 'N/A';
    
    return '${maxHour.key.toString().padLeft(2, '0')}:00';
  }

  int _getUniqueParticipants() {
    final uniqueAuthors = submissions.map((s) => s.authorId).toSet();
    return uniqueAuthors.length;
  }

  double _getEngagementRate() {
    final daysActive = _getDaysActive();
    if (daysActive == 0) return 0.0;
    
    return submissions.length / daysActive;
  }

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

  List<int> _getWeekdayDistribution() {
    final weekdayCount = List<int>.filled(7, 0);
    
    for (final submission in submissions) {
      // DateTime.weekday: 1 = Monday, 7 = Sunday
      final weekday = submission.createdAt.weekday - 1; // Convert to 0-6
      weekdayCount[weekday]++;
    }
    
    return weekdayCount;
  }

    @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mostActiveHour = _getMostActiveHour();
    final uniqueParticipants = _getUniqueParticipants();
    final engagementRate = _getEngagementRate();
    final weekdayDist = _getWeekdayDistribution();
    final maxWeekdayCount = weekdayDist.isEmpty ? 1 : weekdayDist.reduce((a, b) => a > b ? a : b);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Icon(
              Icons.people_outline,
              color: AppColors.pink,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.participationInsights,
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
          l10n.whenUsersEngage,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        // Stats grid
        _buildStatItem(
          icon: Icons.access_time,
          label: l10n.mostActiveHour,
          value: mostActiveHour,
          color: AppColors.pink,
        ),
        const SizedBox(height: 16),
        _buildStatItem(
          icon: Icons.people,
          label: l10n.uniqueParticipants,
          value: uniqueParticipants.toString(),
          color: const Color(0xFF14B8A6),
        ),
        const SizedBox(height: 16),
        _buildStatItem(
          icon: Icons.speed,
          label: l10n.engagementRate,
          value: l10n.perDay(engagementRate.toStringAsFixed(1)),
          color: const Color(0xFF7C3AED),
        ),
        const SizedBox(height: 24),
        
        // Weekday distribution
        Text(
          l10n.activityByDayOfWeek,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        
        if (submissions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.noSubmissionData,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          _buildWeekdayChart(weekdayDist, maxWeekdayCount),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
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

  Widget _buildWeekdayChart(List<int> weekdayDist, int maxCount) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final colors = [
      AppColors.blue,
      const Color(0xFF7C3AED),
      AppColors.pink,
      const Color(0xFF14B8A6),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      AppColors.blue,
    ];
    
    return Column(
      children: List.generate(7, (index) {
        final count = weekdayDist[index];
        final percentage = maxCount > 0 ? count / maxCount : 0.0;
        final color = colors[index];
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  days[index],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color,
                              color.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 28,
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
