import 'package:flutter/material.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../../theme/AppColors.dart';
import '../../../Shared/Models/Models.dart';
import 'EngagementMetrics.dart';
import 'ActivityTimeline.dart';

class DashboardChartsSection extends StatefulWidget {
  final List<Map<String, dynamic>> topicsData;
  final List<Topic> allTopics; // All topics for status distribution
  final int totalSubmissions;
  final int totalUsers;
  final Function(String topicId)? onTopicTap;

  const DashboardChartsSection({
    super.key,
    required this.topicsData,
    required this.allTopics,
    required this.totalSubmissions,
    required this.totalUsers,
    this.onTopicTap,
  });

  @override
  State<DashboardChartsSection> createState() => _DashboardChartsSectionState();
}

class _DashboardChartsSectionState extends State<DashboardChartsSection> {
  bool _isExpanded = true; // Collapsed by default

  @override
  Widget build(BuildContext context) {
    // Take only first 5 topics
    final displayData = widget.topicsData.take(5).toList();
    
    // Find max count for scaling
    final maxCount = displayData.isEmpty 
        ? 1 
        : displayData.map((t) => t['submissionCount'] as int).reduce((a, b) => a > b ? a : b);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with collapse button
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: AppColors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.analyticsDashboard,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.keyMetricsInsights,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
          
          // Animated collapsible content
          AnimatedCrossFade(
            firstChild: Column(
              children: [
                const SizedBox(height: 24),
                
                // Four charts layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    
                    if (isWide) {
                      // Desktop: 2x2 grid
                      return Column(
                        children: [
                          // Row 1: Engagement Overview + Activity Alerts
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: EngagementMetrics(
                                  topics: widget.allTopics,
                                  totalSubmissions: widget.totalSubmissions,
                                  totalUsers: widget.totalUsers,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: ActivityTimeline(
                                  topics: widget.allTopics,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Row 2: Popular Topics + Status Distribution
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildPopularTopicsChart(context, displayData, maxCount),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _buildStatusDistributionChart(context),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // Mobile: stacked
                      return Column(
                        children: [
                          EngagementMetrics(
                            topics: widget.allTopics,
                            totalSubmissions: widget.totalSubmissions,
                            totalUsers: widget.totalUsers,
                          ),
                          const SizedBox(height: 24),
                          ActivityTimeline(
                            topics: widget.allTopics,
                          ),
                          const SizedBox(height: 24),
                          _buildPopularTopicsChart(context, displayData, maxCount),
                          const SizedBox(height: 24),
                          _buildStatusDistributionChart(context),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  // Popular Topics Chart (left side)
  Widget _buildPopularTopicsChart(BuildContext context, List<Map<String, dynamic>> displayData, int maxCount) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title
        Row(
          children: [
            const Icon(
              Icons.bar_chart,
              color: AppColors.blue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.mostPopularTopics,
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
          l10n.topicsWithMostSubmissions,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        
        // Chart content
        if (displayData.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noDataAvailable,
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
          ...displayData.asMap().entries.map((entry) {
            final index = entry.key;
            final topic = entry.value;
            final title = topic['title'] as String;
            final count = topic['submissionCount'] as int;
            final topicId = topic['topicId'] as String;
              
            // Calculate bar width percentage
            final percentage = maxCount > 0 ? (count / maxCount) : 0.0;
            
            // Colors for bars
            final colors = [
              AppColors.blue,
              const Color(0xFF7C3AED),
              AppColors.pink,
              const Color(0xFF14B8A6),
              const Color(0xFFF59E0B),
            ];
            final barColor = colors[index % colors.length];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: widget.onTopicTap != null ? () => widget.onTopicTap!(topicId) : null,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Topic title and count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: barColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: barColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Bar
                    Stack(
                      children: [
                        // Background bar
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Foreground bar
                        FractionallySizedBox(
                          widthFactor: percentage,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: barColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  // Status Distribution Chart (right side) - Circular/Pie Chart
  Widget _buildStatusDistributionChart(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Calculate status distribution from actual topics
    int activeCount = 0;
    int closedCount = 0;
    int scheduledCount = 0;
    
    for (final topic in widget.allTopics) {
      final statusDisplay = topic.statusDisplay;
      switch (statusDisplay) {
        case 'Active':
          activeCount++;
          break;
        case 'Closed':
          closedCount++;
          break;
        case 'Scheduled':
          scheduledCount++;
          break;
      }
    }
    
    final total = activeCount + closedCount + scheduledCount;
    
    // Prepare data for pie chart
    final List<Map<String, dynamic>> statusData = [
      if (activeCount > 0) {
        'label': l10n.active,
        'count': activeCount,
        'color': const Color(0xFF7C3AED), // Purple for Active
        'icon': Icons.play_circle_outline,
      },
      if (scheduledCount > 0) {
        'label': l10n.scheduled,
        'count': scheduledCount,
        'color': AppColors.pink, // Pink for Scheduled
        'icon': Icons.schedule,
      },
      if (closedCount > 0) {
        'label': l10n.closed,
        'count': closedCount,
        'color': const Color(0xFF14B8A6), // Teal for Closed
        'icon': Icons.check_circle_outline,
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title
        Row(
          children: [
            const Icon(
              Icons.pie_chart,
              color: AppColors.pink,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.topicStatusDistribution,
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
          l10n.topicLifecycleOverview,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        // Pie chart and legend
        if (total == 0)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noDataAvailable,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular pie chart
              Expanded(
                flex: 2,
                child: Center(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: CustomPaint(
                      painter: PieChartPainter(statusData: statusData, total: total),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Legend on the right
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: statusData.map((data) {
                    final percentage = (data['count'] / total * 100).toStringAsFixed(1);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          // Color indicator
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: data['color'],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (data['color'] as Color).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Label and count
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['label'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${data['count']} topic${data['count'] > 1 ? 's' : ''} ($percentage%)',
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
                  }).toList(),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// Custom painter for pie chart
class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> statusData;
  final int total;

  PieChartPainter({required this.statusData, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    double startAngle = -90 * (3.14159 / 180); // Start from top (-90 degrees)
    
    for (var data in statusData) {
      final count = data['count'] as int;
      final sweepAngle = (count / total) * 2 * 3.14159;
      final color = data['color'] as Color;
      
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      // Draw pie slice
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      // Draw subtle border between slices
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );
      
      startAngle += sweepAngle;
    }
    
    // Draw center circle for donut effect
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.5, centerPaint);
    
    // Draw center shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.48, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
