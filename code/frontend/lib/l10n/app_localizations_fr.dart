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

  @override
  String get createUser => 'Créer un utilisateur';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get fieldRequired => 'Ce champ est requis';

  @override
  String get invalidEmail => 'Adresse email invalide';

  @override
  String get userCreatedSuccessfully => 'Utilisateur créé avec succès';

  @override
  String get createUserFailed => 'Échec de la création de l\'utilisateur';

  @override
  String get deleteUser => 'Supprimer l\'utilisateur';

  @override
  String get deleteUserConfirm => 'Êtes-vous sûr de vouloir supprimer cet utilisateur ?';

  @override
  String get userDeletedSuccessfully => 'Utilisateur supprimé avec succès';

  @override
  String get deleteUserFailed => 'Échec de la suppression de l\'utilisateur';

  @override
  String get changeRole => 'Changer le rôle';

  @override
  String get role => 'Rôle';

  @override
  String get roleChangedSuccessfully => 'Rôle changé avec succès';

  @override
  String get changeRoleFailed => 'Échec du changement de rôle';

  @override
  String get searchUsers => 'Rechercher par nom, email ou rôle...';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get welcomeMessage => 'Partagez vos perspectives diverses et aidez à façonner de meilleures décisions ensemble';

  @override
  String get activeTopics => 'Sujets actifs';

  @override
  String get yourContributions => 'Vos contributions';

  @override
  String get totalParticipants => 'Participants totaux';

  @override
  String get until => 'Jusqu\'au';

  @override
  String get by => 'Par';

  @override
  String get viewTopic => 'Voir le sujet';

  @override
  String get welcomeToConsensusHub => 'Bienvenue sur Consensus Hub';

  @override
  String get signInMessage => 'Connectez-vous à votre compte pour partager vos perspectives';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get emailPlaceholder => 'vous@exemple.com';

  @override
  String get emailHelperText => 'Astuce : Utilisez admin@endress.com pour la vue administrateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordPlaceholder => 'Entrez votre mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get pleaseEnterEmail => 'Veuillez entrer votre e-mail';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String loginFailedMessage(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get backToSurveys => 'Retour aux sondages';

  @override
  String get createdBy => 'Créé par';

  @override
  String get from => 'Du';

  @override
  String get to => 'au';

  @override
  String get lastUpdated => 'Dernière mise à jour';

  @override
  String get activeTopic => 'Sujet actif';

  @override
  String get closedTopic => 'Sujet fermé';

  @override
  String get scheduledTopic => 'Sujet planifié';

  @override
  String get archivedTopic => 'Sujet archivé';

  @override
  String get summary => 'Résumé';

  @override
  String get detailedDescription => 'Description détaillée';

  @override
  String get timeline => 'Chronologie';

  @override
  String get topicOpens => 'Ouverture du sujet';

  @override
  String get topicCloses => 'Fermeture du sujet';

  @override
  String get created => 'Créé';

  @override
  String get shareYourIdea => 'Partagez votre idée';

  @override
  String get anonymousMessage => 'Toutes les soumissions sont anonymes - votre point de vue compte !';

  @override
  String get yourIdea => 'Votre idée';

  @override
  String get ideaPlaceholder => 'Partagez vos pensées, idées ou préoccupations... (Soyez précis et constructif)';

  @override
  String get multipleSubmissionsMessage => 'Vous pouvez soumettre plusieurs idées. Toutes les soumissions sont anonymes.';

  @override
  String get submitIdea => 'Soumettre l\'idée';

  @override
  String get submitting => 'Envoi en cours...';

  @override
  String get allIdeas => 'Toutes les idées';

  @override
  String get noIdeasYet => 'Aucune idée pour l\'instant';

  @override
  String get beTheFirst => 'Soyez le premier à partager vos pensées !';

  @override
  String get ideaSubmittedSuccess => 'Idée soumise avec succès !';

  @override
  String ideaSubmissionFailed(String error) {
    return 'Échec de la soumission de l\'idée : $error';
  }

  @override
  String get topicNotFound => 'Sujet non trouvé';

  @override
  String get errorLoadingTopic => 'Erreur de chargement du sujet';

  @override
  String get retry => 'Réessayer';

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(int minutes) {
    return 'Il y a ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'Il y a ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'Il y a ${days}j';
  }

  @override
  String get createNewTopic => 'Créer un nouveau sujet de discussion';

  @override
  String get createTopicSubtitle => 'Remplissez les détails pour démarrer une nouvelle discussion communautaire';

  @override
  String get title => 'Titre';

  @override
  String get titlePlaceholder => 'Entrez un titre clair et concis';

  @override
  String get shortDescription => 'Description courte';

  @override
  String get shortDescriptionPlaceholder => 'Aperçu bref du sujet (affiché dans les cartes)';

  @override
  String get fullDescription => 'Description complète';

  @override
  String get fullDescriptionPlaceholder => 'Informations détaillées sur le sujet';

  @override
  String get duration => 'Durée';

  @override
  String get startDate => 'Date de début';

  @override
  String get endDate => 'Date de fin';

  @override
  String get topicCreatedSuccess => 'Sujet créé avec succès !';

  @override
  String topicCreationFailed(String error) {
    return 'Échec de la création du sujet : $error';
  }

  @override
  String get discardChanges => 'Abandonner les modifications ?';

  @override
  String get unsavedChangesMessage => 'Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir partir ?';

  @override
  String get continueEditing => 'Continuer l\'édition';

  @override
  String get discard => 'Abandonner';

  @override
  String get titleRequired => 'Le titre est requis';

  @override
  String get titleTooShort => 'Le titre doit contenir au moins 3 caractères';

  @override
  String get titleTooLong => 'Le titre ne doit pas dépasser 255 caractères';

  @override
  String get shortDescriptionRequired => 'La description courte est requise';

  @override
  String get shortDescriptionTooShort => 'La description courte doit contenir au moins 5 caractères';

  @override
  String get shortDescriptionTooLong => 'La description courte ne doit pas dépasser 500 caractères';

  @override
  String get descriptionRequired => 'La description est requise';

  @override
  String get descriptionTooShort => 'La description doit contenir au moins 10 caractères';

  @override
  String get descriptionTooLong => 'La description ne doit pas dépasser 2500 caractères';

  @override
  String get startDateRequired => 'La date de début est requise';

  @override
  String get endDateRequired => 'La date de fin est requise';

  @override
  String get endDateMustBeAfterStart => 'La date de fin doit être après la date de début';

  @override
  String get updateDiscussionTopic => 'Mettre à jour le sujet de discussion';

  @override
  String get modifyTopicDetails => 'Modifier les détails de ce sujet de discussion';

  @override
  String get pageNotFound => 'Page non trouvée';

  @override
  String get notFoundNumber => '404';

  @override
  String get pageNotFoundMessage => 'La page que vous recherchez n\'existe pas ou a été déplacée.';

  @override
  String get goToDashboard => 'Aller au tableau de bord';

  @override
  String get goToLogin => 'Aller à la connexion';

  @override
  String get accessDenied => 'Accès refusé';

  @override
  String get noPermissionMessage => 'Vous n\'avez pas la permission d\'accéder à cette page.';

  @override
  String get userNotAuthenticated => 'Utilisateur non authentifié';
}
