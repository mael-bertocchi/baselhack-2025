import 'package:flutter/material.dart';
import '../../Application/SurveyDetail/UI/SurveyDetailView.dart';
import '../../Application/Dashboard/UI/Components/TopicCard.dart';

// Alias temporaire pour rétrocompatibilité
typedef Survey = Topic;

class SurveyDetailPage extends StatelessWidget {
  final Survey survey;

  const SurveyDetailPage({
    super.key,
    required this.survey,
  });

  @override
  Widget build(BuildContext context) {
    return SurveyDetailView(survey: survey);
  }
}
