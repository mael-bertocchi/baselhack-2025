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
  String get editTopic => 'Thema bearbeiten';

  @override
  String get deleteTopic => 'Thema löschen';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String get deleteTopicMessage => 'Sind Sie sicher, dass Sie dieses Thema löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get topicDeleted => 'Thema erfolgreich gelöscht';

  @override
  String get deleteTopicFailed => 'Fehler beim Löschen des Themas';

  @override
  String get updateTopic => 'Thema aktualisieren';

  @override
  String get topicUpdated => 'Thema erfolgreich aktualisiert';

  @override
  String get updateTopicFailed => 'Fehler beim Aktualisieren des Themas';

  @override
  String get manageAccounts => 'Konten verwalten';

  @override
  String get errorLoadingUsers => 'Fehler beim Laden der Benutzer';

  @override
  String get noUsersFound => 'Keine Benutzer gefunden';

  @override
  String get joinedOn => 'Beigetreten am';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get passwordTooShort => 'Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get passwordChangedSuccessfully => 'Passwort erfolgreich geändert';

  @override
  String get changePasswordFailed => 'Fehler beim Ändern des Passworts';

  @override
  String get save => 'Speichern';

  @override
  String get createUser => 'Benutzer erstellen';

  @override
  String get firstName => 'Vorname';

  @override
  String get lastName => 'Nachname';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get fieldRequired => 'Dieses Feld ist erforderlich';

  @override
  String get invalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get userCreatedSuccessfully => 'Benutzer erfolgreich erstellt';

  @override
  String get createUserFailed => 'Fehler beim Erstellen des Benutzers';

  @override
  String get deleteUser => 'Benutzer löschen';

  @override
  String get deleteUserConfirm => 'Möchten Sie diesen Benutzer wirklich löschen?';

  @override
  String get userDeletedSuccessfully => 'Benutzer erfolgreich gelöscht';

  @override
  String get deleteUserFailed => 'Fehler beim Löschen des Benutzers';

  @override
  String get changeRole => 'Rolle ändern';

  @override
  String get role => 'Rolle';

  @override
  String get roleChangedSuccessfully => 'Rolle erfolgreich geändert';

  @override
  String get changeRoleFailed => 'Fehler beim Ändern der Rolle';

  @override
  String get searchUsers => 'Suche nach Name, E-Mail oder Rolle...';
}
