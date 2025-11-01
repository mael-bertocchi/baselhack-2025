import 'package:flutter/material.dart';
import 'package:frontend/src/Application/UpdateTopic/UI/UpdateTopicView.dart';
import 'package:frontend/src/Application/Dashboard/UI/Components/TopicCard.dart';

class UpdateTopicPage extends StatelessWidget {
  final Topic topic;

  const UpdateTopicPage({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return UpdateTopicView(topic: topic);
  }
}
