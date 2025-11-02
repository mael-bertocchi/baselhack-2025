// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Alignify';

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
  String statusTopic(String status) {
    return 'Sujet $status';
  }

  @override
  String get noTopicsFound => 'Aucun sujet trouvé';

  @override
  String get tryAdjustingSearch => 'Essayez d\'ajuster vos termes de recherche';

  @override
  String get errorLoadingTopics => 'Erreur de chargement des sujets';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get welcomeBack => 'Bienvenue !';

  @override
  String get sharePerspectives => 'Partagez vos diverses perspectives et contribuez à façonner de meilleures décisions ensemble';

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
  String get welcomeToConsensusHub => 'Bienvenue sur Alignify';

  @override
  String get signInToAccount => 'Connectez-vous à votre compte pour partager vos idées';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get emailPlaceholder => 'vous@exemple.com';

  @override
  String get emailHelperText => 'Astuce : Utilisez admin@endress.com pour la vue administrateur';

  @override
  String get passwordPlaceholder => 'Entrez votre mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get pleaseEnterEmail => 'Veuillez entrer votre adresse e-mail';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String loginFailed(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get accessDenied => 'Accès refusé';

  @override
  String get noPermission => 'Vous n\'avez pas la permission d\'accéder à ce contenu.';

  @override
  String get goToDashboard => 'Aller au tableau de bord';

  @override
  String get topicNotFound => 'Sujet non trouvé';

  @override
  String failedToLoadTopic(String error) {
    return 'Échec du chargement du sujet : $error';
  }

  @override
  String get ideaSubmittedSuccessfully => 'Idée soumise avec succès !';

  @override
  String failedToSubmitIdea(String error) {
    return 'Échec de la soumission de l\'idée : $error';
  }

  @override
  String get shareYourIdea => 'Partagez votre idée';

  @override
  String get anonymousSubmissions => 'Toutes les soumissions sont anonymes - votre perspective compte !';

  @override
  String get yourIdea => 'Votre idée';

  @override
  String get ideaPlaceholder => 'Partagez vos pensées, idées ou préoccupations... (Soyez précis et constructif)';

  @override
  String get multipleSubmissionsNote => 'Vous pouvez soumettre plusieurs idées. Toutes les soumissions sont anonymes.';

  @override
  String get submitting => 'Envoi en cours...';

  @override
  String get submitIdea => 'Soumettre l\'idée';

  @override
  String get allIdeas => 'Toutes les idées';

  @override
  String get retry => 'Réessayer';

  @override
  String get noIdeasYet => 'Pas encore d\'idées';

  @override
  String get beFirstToShare => 'Soyez le premier à partager vos idées !';

  @override
  String get generateAiSummary => 'Générer le résumé IA';

  @override
  String get analyzing => 'Analyse en cours...';

  @override
  String get noIdeasToAnalyze => 'Aucune idée à analyser';

  @override
  String timeAgo(String time) {
    return 'Il y a $time';
  }

  @override
  String get justNow => 'À l\'instant';

  @override
  String daysShort(int count) {
    return '${count}j';
  }

  @override
  String hoursShort(int count) {
    return '${count}h';
  }

  @override
  String minutesShort(int count) {
    return '${count}m';
  }

  @override
  String get startDate => 'Date de début';

  @override
  String get endDate => 'Date de fin';

  @override
  String get topicCreatedSuccessfully => 'Sujet créé avec succès !';

  @override
  String failedToCreateTopic(String error) {
    return 'Échec de la création du sujet : $error';
  }

  @override
  String get discardChanges => 'Annuler les modifications ?';

  @override
  String get unsavedChangesMessage => 'Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir quitter ?';

  @override
  String get continueEditing => 'Continuer la modification';

  @override
  String get discard => 'Abandonner';

  @override
  String get createNewDiscussionTopic => 'Créer un nouveau sujet de discussion';

  @override
  String get fillDetailsToStart => 'Remplissez les détails pour démarrer une nouvelle discussion communautaire';

  @override
  String get title => 'Titre';

  @override
  String get titleHint => 'Entrez un titre clair et concis';

  @override
  String get shortDescription => 'Description courte';

  @override
  String get shortDescriptionHint => 'Aperçu bref du sujet (affiché dans les cartes)';

  @override
  String get fullDescription => 'Description complète';

  @override
  String get fullDescriptionHint => 'Informations détaillées sur le sujet';

  @override
  String get duration => 'Durée';

  @override
  String get titleRequired => 'Le titre est requis';

  @override
  String get titleMinLength => 'Le titre doit contenir au moins 3 caractères';

  @override
  String get titleMaxLength => 'Le titre ne doit pas dépasser 255 caractères';

  @override
  String get shortDescriptionRequired => 'La description courte est requise';

  @override
  String get shortDescriptionMinLength => 'La description courte doit contenir au moins 5 caractères';

  @override
  String get shortDescriptionMaxLength => 'La description courte ne doit pas dépasser 500 caractères';

  @override
  String get descriptionRequired => 'La description est requise';

  @override
  String get descriptionMinLength => 'La description doit contenir au moins 10 caractères';

  @override
  String get descriptionMaxLength => 'La description ne doit pas dépasser 2500 caractères';

  @override
  String get startDateRequired => 'La date de début est requise';

  @override
  String get endDateRequired => 'La date de fin est requise';

  @override
  String get endDateAfterStart => 'La date de fin doit être après la date de début';

  @override
  String get userNotAuthenticated => 'Utilisateur non authentifié';

  @override
  String get topicUpdatedSuccessfully => 'Sujet mis à jour avec succès !';

  @override
  String failedToUpdateTopic(String error) {
    return 'Échec de la mise à jour du sujet : $error';
  }

  @override
  String get errorTopicIdNotProvided => 'Erreur : ID du sujet non fourni';

  @override
  String get errorLoadingTopic => 'Erreur de chargement du sujet';

  @override
  String get backToSurveys => 'Retour aux sondages';

  @override
  String get detailedDescription => 'Description détaillée';

  @override
  String get topicOpens => 'Ouverture du sujet';

  @override
  String get topicCloses => 'Fermeture du sujet';

  @override
  String get updateDiscussionTopic => 'Mettre à jour le sujet de discussion';

  @override
  String get modifyDetailsMessage => 'Modifier les détails de ce sujet de discussion';

  @override
  String get goToLogin => 'Aller à la connexion';

  @override
  String get pageNotFound => 'Page non trouvée';

  @override
  String get pageNotFoundMessage => 'La page que vous recherchez n\'existe pas.';

  @override
  String get createdBy => 'Créé par';

  @override
  String get from => 'Du';

  @override
  String get to => 'au';

  @override
  String get lastUpdated => 'Dernière mise à jour';

  @override
  String get timeline => 'Chronologie';

  @override
  String get created => 'Créé';

  @override
  String get until => 'Jusqu\'au';

  @override
  String get viewTopic => 'Voir le sujet';

  @override
  String get by => 'Par';

  @override
  String get summary => 'Résumé';

  @override
  String get aiGeneratedSummary => 'Résumé généré par IA';

  @override
  String get automatedAnalysisDesc => 'Analyse automatisée de toutes les idées et tendances soumises';

  @override
  String lastUpdatedDate(String date) {
    return 'Dernière mise à jour : $date';
  }

  @override
  String get aiAnalysisCompleted => 'Analyse IA terminée avec succès !';

  @override
  String failedToAnalyzeTopic(String error) {
    return 'Échec de l\'analyse du sujet : $error';
  }

  @override
  String get activeTopics => 'Sujets actifs';

  @override
  String get yourContributions => 'Vos contributions';

  @override
  String get totalContributions => 'Total des contributions';

  @override
  String get totalParticipants => 'Total des participants';

  @override
  String get mostPopularTopics => 'Sujets les plus populaires';

  @override
  String get topicsWithMostSubmissions => 'Sujets avec le plus de contributions';

  @override
  String get noDataAvailable => 'Aucune donnée disponible';

  @override
  String get analyticsDashboard => 'Tableau de bord analytique';

  @override
  String get keyMetricsInsights => 'Indicateurs clés et analyses';

  @override
  String get topicStatusDistribution => 'Répartition des statuts';

  @override
  String get topicLifecycleOverview => 'Vue d\'ensemble du cycle de vie';

  @override
  String get engagementOverview => 'Vue d\'ensemble de l\'engagement';

  @override
  String get platformActivityMetrics => 'Métriques d\'activité de la plateforme';

  @override
  String get aiSummaryCoverage => 'Couverture\nrésumé IA';

  @override
  String get topicParticipation => 'Participation\naux sujets';

  @override
  String get pendingSummary => 'Résumé en attente';

  @override
  String get avgPerTopic => 'Moy. par sujet';

  @override
  String get activityAlerts => 'Alertes d\'activité';

  @override
  String get importantUpdatesNotifications => 'Mises à jour et notifications importantes';

  @override
  String get newTopics => 'Nouveaux sujets';

  @override
  String createdThisWeek(int count) {
    return '$count créés cette semaine';
  }

  @override
  String get closingSoon => 'Bientôt fermés';

  @override
  String topicsEndingInDays(int count) {
    return '$count sujets se terminent dans 3 jours';
  }

  @override
  String get needsAttention => 'Nécessite attention';

  @override
  String topicsLowEngagement(int count) {
    return '$count sujets avec faible engagement';
  }

  @override
  String get topicAnalytics => 'Analyses du Sujet';

  @override
  String get detailedInsightsEngagement => 'Analyses détaillées et métriques d\'engagement';

  @override
  String get refresh => 'Actualiser';

  @override
  String get engagementOverviewTitle => 'Vue d\'ensemble de l\'engagement';

  @override
  String get keyMetricsForTopic => 'Indicateurs clés pour ce sujet';

  @override
  String get totalSubmissions => 'Total des soumissions';

  @override
  String get avgPerDay => 'Moy. par jour';

  @override
  String get daysActive => 'Jours actifs';

  @override
  String get aiAnalysis => 'Analyse IA';

  @override
  String get complete => 'Terminé';

  @override
  String get pending => 'En attente';

  @override
  String get topicProgress => 'Progression du sujet';

  @override
  String get topicPeriodEnded => 'La période du sujet est terminée';

  @override
  String daysElapsed(int active, int total) {
    return '$active jours sur $total écoulés';
  }

  @override
  String get submissionTimeline => 'Chronologie des soumissions';

  @override
  String get dailySubmissionActivity => 'Activité quotidienne des soumissions';

  @override
  String get noSubmissionData => 'Aucune donnée de soumission';

  @override
  String get peak => 'Pic';

  @override
  String get average => 'Moyenne';

  @override
  String get totalDays => 'Total de jours';

  @override
  String get participationInsights => 'Analyse de participation';

  @override
  String get whenUsersEngage => 'Quand les utilisateurs s\'engagent le plus';

  @override
  String get mostActiveHour => 'Heure la plus active';

  @override
  String get uniqueParticipants => 'Participants uniques';

  @override
  String get engagementRate => 'Taux d\'engagement';

  @override
  String perDay(String rate) {
    return '$rate/jour';
  }

  @override
  String get activityByDayOfWeek => 'Activité par jour de la semaine';

  @override
  String get commonThemes => 'Thèmes communs';

  @override
  String get mostFrequentWords => 'Mots les plus fréquents dans les soumissions';

  @override
  String get noThemesDetected => 'Aucun thème détecté';

  @override
  String get topWordsExcludingCommon => 'Top 10 des mots (hors mots courants)';
}
