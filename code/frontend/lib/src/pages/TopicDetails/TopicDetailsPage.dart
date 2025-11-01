import 'package:flutter/material.dart';
import 'package:frontend/src/Application/TopicDetail/UI/TopicDetailView.dart';

/// Page wrapper for Topic Details page
/// This maintains consistency with the application's page structure
/// Extracts the topic ID from route arguments
class TopicDetailsPage extends StatelessWidget {
  const TopicDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract topic ID from route arguments
    final topicId = ModalRoute.of(context)?.settings.arguments as String?;
    
    if (topicId == null) {
      return Scaffold(
        body: Center(
          child: Text('Error: Topic ID not provided'),
        ),
      );
    }
    
    return TopicDetailView(topicId: topicId);
  }
}
