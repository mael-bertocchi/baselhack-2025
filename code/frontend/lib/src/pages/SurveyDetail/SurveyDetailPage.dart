import 'package:flutter/material.dart';
import '../../Application/SurveyDetail/UI/SurveyDetailView.dart';
import '../../Application/Dashboard/UI/Components/SurveyCard.dart';

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
