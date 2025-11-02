import 'package:flutter/material.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../../../../theme/AppColors.dart';
import '../../../Shared/Models/Models.dart';
import 'dart:math' as math;

class SubmissionTrendChart extends StatelessWidget {
  final Topic topic;
  final List<Idea> submissions;

  const SubmissionTrendChart({
    super.key,
    required this.topic,
    required this.submissions,
  });

  Map<DateTime, int> _groupSubmissionsByDay() {
    final Map<DateTime, int> groupedData = {};
    
    for (final submission in submissions) {
      final date = DateTime(
        submission.createdAt.year,
        submission.createdAt.month,
        submission.createdAt.day,
      );
      
      groupedData[date] = (groupedData[date] ?? 0) + 1;
    }
    
    return groupedData;
  }

  List<MapEntry<DateTime, int>> _getPaddedData() {
    final groupedData = _groupSubmissionsByDay();
    
    // Create a list of all dates in the topic period
    final startDate = DateTime(
      topic.startDate.year,
      topic.startDate.month,
      topic.startDate.day,
    );
    
    final now = DateTime.now();
    final endDate = DateTime(
      topic.endDate.year,
      topic.endDate.month,
      topic.endDate.day,
    );
    
    final actualEndDate = now.isBefore(endDate) 
      ? DateTime(now.year, now.month, now.day)
      : endDate;
    
    final List<MapEntry<DateTime, int>> paddedData = [];
    
    DateTime currentDate = startDate;
    while (currentDate.isBefore(actualEndDate) || currentDate.isAtSameMomentAs(actualEndDate)) {
      paddedData.add(MapEntry(currentDate, groupedData[currentDate] ?? 0));
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return paddedData;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final paddedData = _getPaddedData();
    
    if (paddedData.isEmpty) {
      return _buildEmptyState(context);
    }
    
    final maxCount = paddedData.map((e) => e.value).reduce(math.max);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Icon(
              Icons.show_chart,
              color: const Color(0xFF7C3AED),
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.submissionTimeline,
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
          l10n.dailySubmissionActivity,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        // Chart
        SizedBox(
          height: 180,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, 180),
                painter: LineChartPainter(
                  data: paddedData,
                  maxValue: maxCount > 0 ? maxCount : 1,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Legend
        _buildLegend(context, paddedData, maxCount),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.show_chart,
              color: const Color(0xFF7C3AED),
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              l10n.submissionTimeline,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Column(
              children: [
                Icon(
                  Icons.timeline,
                  size: 48,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noSubmissionData,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, List<MapEntry<DateTime, int>> data, int maxCount) {
    if (data.isEmpty) return const SizedBox.shrink();
    
    final l10n = AppLocalizations.of(context)!;
    final totalSubmissions = data.fold<int>(0, (sum, entry) => sum + entry.value);
    final avgSubmissions = (totalSubmissions / data.length).toStringAsFixed(1);
    final peakDay = data.reduce((a, b) => a.value > b.value ? a : b);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(
            label: l10n.peak,
            value: '${peakDay.value}',
            color: const Color(0xFF7C3AED),
          ),
          _buildLegendItem(
            label: l10n.average,
            value: avgSubmissions,
            color: AppColors.blue,
          ),
          _buildLegendItem(
            label: l10n.totalDays,
            value: '${data.length}',
            color: AppColors.pink,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<MapEntry<DateTime, int>> data;
  final int maxValue;

  LineChartPainter({
    required this.data,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxValue == 0) return;
    
    final paint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF7C3AED).withOpacity(0.3),
          const Color(0xFF7C3AED).withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    
    final pointPaint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..style = PaintingStyle.fill;
    
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
    
    // Calculate points
    final path = Path();
    final fillPath = Path();
    final points = <Offset>[];
    
    final stepX = size.width / (data.length - 1).clamp(1, double.infinity);
    
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = data[i].value / maxValue;
      final y = size.height - (normalizedValue * size.height);
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    
    // Complete fill path
    if (points.isNotEmpty) {
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.close();
    }
    
    // Draw fill
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw line
    canvas.drawPath(path, paint);
    
    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
