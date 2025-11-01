// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Consensus Hub';

  @override
  String get detailsTitle => 'Details';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get user => 'User';

  @override
  String get administrator => 'Administrator';

  @override
  String get manager => 'Manager';

  @override
  String get searchTopics => 'Search topics...';

  @override
  String get allTopics => 'All Topics';

  @override
  String get active => 'Active';

  @override
  String get closed => 'Closed';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get archived => 'Archived';

  @override
  String get createTopic => 'Create Topic';

  @override
  String get noTopicsFound => 'No topics found';

  @override
  String get tryAdjustingSearch => 'Try adjusting your search terms';

  @override
  String get errorLoadingTopics => 'Error Loading Topics';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get loading => 'Loading...';

  @override
  String logoutFailed(String error) {
    return 'Logout failed: $error';
  }

  @override
  String get editTopic => 'Edit Topic';

  @override
  String get deleteTopic => 'Delete Topic';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteTopicMessage => 'Are you sure you want to delete this topic? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get topicDeleted => 'Topic deleted successfully';

  @override
  String get deleteTopicFailed => 'Failed to delete topic';

  @override
  String get updateTopic => 'Update Topic';

  @override
  String get topicUpdated => 'Topic updated successfully';

  @override
  String get updateTopicFailed => 'Failed to update topic';
}
