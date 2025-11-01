// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Konsens Hub';

  @override
  String get detailsTitle => 'Details';

  @override
  String get logout => 'Abmelden';

  @override
  String get language => 'Sprache';

  @override
  String get user => 'Benutzer';

  @override
  String get administrator => 'Administrator';

  @override
  String get manager => 'Manager';

  @override
  String get searchTopics => 'Themen suchen...';

  @override
  String get allTopics => 'Alle Themen';

  @override
  String get active => 'Aktiv';

  @override
  String get closed => 'Geschlossen';

  @override
  String get scheduled => 'Geplant';

  @override
  String get archived => 'Archiviert';

  @override
  String get createTopic => 'Thema erstellen';

  @override
  String get noTopicsFound => 'Keine Themen gefunden';

  @override
  String get tryAdjustingSearch => 'Versuchen Sie, Ihre Suchbegriffe anzupassen';

  @override
  String get errorLoadingTopics => 'Fehler beim Laden der Themen';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get loading => 'Wird geladen...';

  @override
  String logoutFailed(String error) {
    return 'Abmeldung fehlgeschlagen: $error';
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
