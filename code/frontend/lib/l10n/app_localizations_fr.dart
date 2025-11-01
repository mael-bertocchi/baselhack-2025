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

  @override
  String get editTopic => 'Modifier le sujet';

  @override
  String get deleteTopic => 'Supprimer le sujet';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get deleteTopicMessage => 'Êtes-vous sûr de vouloir supprimer ce sujet ? Cette action ne peut pas être annulée.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get topicDeleted => 'Sujet supprimé avec succès';

  @override
  String get deleteTopicFailed => 'Échec de la suppression du sujet';

  @override
  String get updateTopic => 'Mettre à jour le sujet';

  @override
  String get topicUpdated => 'Sujet mis à jour avec succès';

  @override
  String get updateTopicFailed => 'Échec de la mise à jour du sujet';

  @override
  String get manageAccounts => 'Gérer les comptes';

  @override
  String get errorLoadingUsers => 'Erreur lors du chargement des utilisateurs';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé';

  @override
  String get joinedOn => 'Inscrit le';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordTooShort => 'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get passwordChangedSuccessfully => 'Mot de passe changé avec succès';

  @override
  String get changePasswordFailed => 'Échec du changement de mot de passe';

  @override
  String get save => 'Enregistrer';
}
