// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Hub Consensus';

  @override
  String get detailsTitle => 'Détails';

  @override
  String get logout => 'Déconnexion';

  @override
  String get language => 'Langue';

  @override
  String get user => 'Utilisateur';

  @override
  String get administrator => 'Administrateur';

  @override
  String get manager => 'Gestionnaire';

  @override
  String get searchTopics => 'Rechercher des sujets...';

  @override
  String get allTopics => 'Tous les sujets';

  @override
  String get active => 'Actif';

  @override
  String get closed => 'Fermé';

  @override
  String get scheduled => 'Planifié';

  @override
  String get archived => 'Archivé';

  @override
  String get createTopic => 'Créer un sujet';

  @override
  String get noTopicsFound => 'Aucun sujet trouvé';

  @override
  String get tryAdjustingSearch => 'Essayez d\'ajuster vos termes de recherche';

  @override
  String get errorLoadingTopics => 'Erreur de chargement des sujets';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String logoutFailed(String error) {
    return 'Échec de la déconnexion : $error';
  }
}
