import 'package:flutter/material.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../../theme/AppColors.dart';
import '../../../Shared/Models/Models.dart';
import 'SubmissionTrendChart.dart';
import 'TopicEngagementCard.dart';
import 'ParticipationInsights.dart';
import 'SubmissionWordCloud.dart';

class TopicAnalyticsSection extends StatefulWidget {
  final Topic topic;
  final List<Idea> submissions;
  final TopicResult? aiSummary;
  final Function()? onRefresh;

  const TopicAnalyticsSection({
    super.key,
    required this.topic,
    required this.submissions,
    this.aiSummary,
    this.onRefresh,
  });

  @override
  State<TopicAnalyticsSection> createState() => _TopicAnalyticsSectionState();
}

class _TopicAnalyticsSectionState extends State<TopicAnalyticsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.blue.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue,
                        AppColors.blue.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.insights,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.topicAnalytics,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.detailedInsightsEngagement,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onRefresh != null)
                  IconButton(
                    onPressed: widget.onRefresh,
                    icon: const Icon(Icons.refresh),
                    color: AppColors.blue,
                    tooltip: l10n.refresh,
                  ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                  size: 28,
                ),
              ],
            ),
          ),
          
          // Animated collapsible content
          AnimatedCrossFade(
            firstChild: Column(
              children: [
                const SizedBox(height: 24),
                
                // Analytics layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    
                    if (isWide) {
                      // Desktop: 2x2 grid with different arrangement
                      return Column(
                        children: [
                          // Row 1: Engagement Card + Participation Insights
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: TopicEngagementCard(
                                  topic: widget.topic,
                                  totalSubmissions: widget.submissions.length,
                                  hasAiSummary: widget.aiSummary != null,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 2,
                                child: ParticipationInsights(
                                  topic: widget.topic,
                                  submissions: widget.submissions,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Row 2: Submission Trend + Word Cloud
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: SubmissionTrendChart(
                                  topic: widget.topic,
                                  submissions: widget.submissions,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 2,
                                child: SubmissionWordCloud(
                                  submissions: widget.submissions,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // Mobile: stacked
                      return Column(
                        children: [
                          TopicEngagementCard(
                            topic: widget.topic,
                            totalSubmissions: widget.submissions.length,
                            hasAiSummary: widget.aiSummary != null,
                          ),
                          const SizedBox(height: 24),
                          SubmissionTrendChart(
                            topic: widget.topic,
                            submissions: widget.submissions,
                          ),
                          const SizedBox(height: 24),
                          ParticipationInsights(
                            topic: widget.topic,
                            submissions: widget.submissions,
                          ),
                          const SizedBox(height: 24),
                          SubmissionWordCloud(
                            submissions: widget.submissions,
                          ),
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
}
