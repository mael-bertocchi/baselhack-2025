import 'package:flutter/material.dart';
import 'package:frontend/src/Application/UpdateTopic/UI/UpdateTopicView.dart';
import 'package:frontend/l10n/app_localizations.dart';

class UpdateTopicPage extends StatelessWidget {
  const UpdateTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Extract topic ID from route arguments
    final topicId = ModalRoute.of(context)?.settings.arguments as String?;
    
    if (topicId == null) {
      return Scaffold(
        body: Center(
          child: Text(l10n.errorTopicIdNotProvided),
        ),
      );
    }
    
    return UpdateTopicView(topicId: topicId);
  }
}
