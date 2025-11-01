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

  @override
  String get welcomeBack => 'Willkommen zurück!';

  @override
  String get welcomeMessage => 'Teilen Sie Ihre verschiedenen Perspektiven und helfen Sie mit, bessere Entscheidungen gemeinsam zu treffen';

  @override
  String get activeTopics => 'Aktive Themen';

  @override
  String get yourContributions => 'Ihre Beiträge';

  @override
  String get totalParticipants => 'Gesamtteilnehmer';

  @override
  String get until => 'Bis';

  @override
  String get by => 'Von';

  @override
  String get viewTopic => 'Thema ansehen';

  @override
  String get welcomeToConsensusHub => 'Willkommen bei Consensus Hub';

  @override
  String get signInMessage => 'Melden Sie sich an, um Ihre Einblicke zu teilen';

  @override
  String get emailAddress => 'E-Mail-Adresse';

  @override
  String get emailPlaceholder => 'sie@beispiel.com';

  @override
  String get emailHelperText => 'Tipp: Verwenden Sie admin@endress.com für die Administrator-Ansicht';

  @override
  String get password => 'Passwort';

  @override
  String get passwordPlaceholder => 'Geben Sie Ihr Passwort ein';

  @override
  String get signIn => 'Anmelden';

  @override
  String get pleaseEnterEmail => 'Bitte geben Sie Ihre E-Mail ein';

  @override
  String get pleaseEnterPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String loginFailedMessage(String error) {
    return 'Anmeldung fehlgeschlagen: $error';
  }

  @override
  String get backToSurveys => 'Zurück zu Umfragen';

  @override
  String get createdBy => 'Erstellt von';

  @override
  String get from => 'Vom';

  @override
  String get to => 'bis';

  @override
  String get lastUpdated => 'Zuletzt aktualisiert';

  @override
  String get activeTopic => 'Aktives Thema';

  @override
  String get closedTopic => 'Geschlossenes Thema';

  @override
  String get scheduledTopic => 'Geplantes Thema';

  @override
  String get archivedTopic => 'Archiviertes Thema';

  @override
  String get summary => 'Zusammenfassung';

  @override
  String get detailedDescription => 'Detaillierte Beschreibung';

  @override
  String get timeline => 'Zeitachse';

  @override
  String get topicOpens => 'Thema öffnet';

  @override
  String get topicCloses => 'Thema schließt';

  @override
  String get created => 'Erstellt';

  @override
  String get shareYourIdea => 'Teilen Sie Ihre Idee';

  @override
  String get anonymousMessage => 'Alle Einreichungen sind anonym - Ihre Perspektive zählt!';

  @override
  String get yourIdea => 'Ihre Idee';

  @override
  String get ideaPlaceholder => 'Teilen Sie Ihre Gedanken, Ideen oder Bedenken... (Seien Sie spezifisch und konstruktiv)';

  @override
  String get multipleSubmissionsMessage => 'Sie können mehrere Ideen einreichen. Alle Einreichungen sind anonym.';

  @override
  String get submitIdea => 'Idee einreichen';

  @override
  String get submitting => 'Wird gesendet...';

  @override
  String get allIdeas => 'Alle Ideen';

  @override
  String get noIdeasYet => 'Noch keine Ideen';

  @override
  String get beTheFirst => 'Seien Sie der Erste, der seine Gedanken teilt!';

  @override
  String get ideaSubmittedSuccess => 'Idee erfolgreich eingereicht!';

  @override
  String ideaSubmissionFailed(String error) {
    return 'Fehler beim Einreichen der Idee: $error';
  }

  @override
  String get topicNotFound => 'Thema nicht gefunden';

  @override
  String get errorLoadingTopic => 'Fehler beim Laden des Themas';

  @override
  String get retry => 'Wiederholen';

  @override
  String get justNow => 'Gerade eben';

  @override
  String minutesAgo(int minutes) {
    return 'Vor ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'Vor ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'Vor ${days}d';
  }

  @override
  String get createNewTopic => 'Neues Diskussionsthema erstellen';

  @override
  String get createTopicSubtitle => 'Füllen Sie die Details aus, um eine neue Community-Diskussion zu starten';

  @override
  String get title => 'Titel';

  @override
  String get titlePlaceholder => 'Geben Sie einen klaren und prägnanten Titel ein';

  @override
  String get shortDescription => 'Kurze Beschreibung';

  @override
  String get shortDescriptionPlaceholder => 'Kurze Übersicht über das Thema (wird in Karten angezeigt)';

  @override
  String get fullDescription => 'Vollständige Beschreibung';

  @override
  String get fullDescriptionPlaceholder => 'Detaillierte Informationen zum Thema';

  @override
  String get duration => 'Dauer';

  @override
  String get startDate => 'Startdatum';

  @override
  String get endDate => 'Enddatum';

  @override
  String get topicCreatedSuccess => 'Thema erfolgreich erstellt!';

  @override
  String topicCreationFailed(String error) {
    return 'Fehler beim Erstellen des Themas: $error';
  }

  @override
  String get discardChanges => 'Änderungen verwerfen?';

  @override
  String get unsavedChangesMessage => 'Sie haben nicht gespeicherte Änderungen. Sind Sie sicher, dass Sie gehen möchten?';

  @override
  String get continueEditing => 'Bearbeitung fortsetzen';

  @override
  String get discard => 'Verwerfen';

  @override
  String get titleRequired => 'Titel ist erforderlich';

  @override
  String get titleTooShort => 'Titel muss mindestens 3 Zeichen lang sein';

  @override
  String get titleTooLong => 'Titel darf 255 Zeichen nicht überschreiten';

  @override
  String get shortDescriptionRequired => 'Kurze Beschreibung ist erforderlich';

  @override
  String get shortDescriptionTooShort => 'Kurze Beschreibung muss mindestens 5 Zeichen lang sein';

  @override
  String get shortDescriptionTooLong => 'Kurze Beschreibung darf 500 Zeichen nicht überschreiten';

  @override
  String get descriptionRequired => 'Beschreibung ist erforderlich';

  @override
  String get descriptionTooShort => 'Beschreibung muss mindestens 10 Zeichen lang sein';

  @override
  String get descriptionTooLong => 'Beschreibung darf 2500 Zeichen nicht überschreiten';

  @override
  String get startDateRequired => 'Startdatum ist erforderlich';

  @override
  String get endDateRequired => 'Enddatum ist erforderlich';

  @override
  String get endDateMustBeAfterStart => 'Enddatum muss nach dem Startdatum liegen';

  @override
  String get updateDiscussionTopic => 'Diskussionsthema aktualisieren';

  @override
  String get modifyTopicDetails => 'Details dieses Diskussionsthemas ändern';

  @override
  String get pageNotFound => 'Seite nicht gefunden';

  @override
  String get notFoundNumber => '404';

  @override
  String get pageNotFoundMessage => 'Die gesuchte Seite existiert nicht oder wurde verschoben.';

  @override
  String get goToDashboard => 'Zum Dashboard gehen';

  @override
  String get goToLogin => 'Zur Anmeldung gehen';

  @override
  String get accessDenied => 'Zugriff verweigert';

  @override
  String get noPermissionMessage => 'Sie haben keine Berechtigung, auf diese Seite zuzugreifen.';

  @override
  String get userNotAuthenticated => 'Benutzer nicht authentifiziert';
}
