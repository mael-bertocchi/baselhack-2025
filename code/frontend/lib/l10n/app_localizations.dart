import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr')
  ];

  /// Title for the application
  ///
  /// In en, this message translates to:
  /// **'Alignify'**
  String get appTitle;

  /// Title for details pages
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Language selector label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Default user label
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Administrator role
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// Manager role
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// Search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search topics...'**
  String get searchTopics;

  /// All topics filter
  ///
  /// In en, this message translates to:
  /// **'All Topics'**
  String get allTopics;

  /// Active status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Closed status
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// Scheduled status
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// Archived status
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// Create topic button
  ///
  /// In en, this message translates to:
  /// **'Create Topic'**
  String get createTopic;

  /// Status topic label
  ///
  /// In en, this message translates to:
  /// **'{status} Topic'**
  String statusTopic(String status);

  /// No topics message
  ///
  /// In en, this message translates to:
  /// **'No topics found'**
  String get noTopicsFound;

  /// Search help message
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get tryAdjustingSearch;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error Loading Topics'**
  String get errorLoadingTopics;

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Dashboard welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Dashboard subtitle
  ///
  /// In en, this message translates to:
  /// **'Share your diverse perspectives and help shape better decisions together'**
  String get sharePerspectives;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Logout error message
  ///
  /// In en, this message translates to:
  /// **'Logout failed: {error}'**
  String logoutFailed(String error);

  /// Edit topic button
  ///
  /// In en, this message translates to:
  /// **'Edit Topic'**
  String get editTopic;

  /// Delete topic button
  ///
  /// In en, this message translates to:
  /// **'Delete Topic'**
  String get deleteTopic;

  /// Delete confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this topic? This action cannot be undone.'**
  String get deleteTopicMessage;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Topic deletion success message
  ///
  /// In en, this message translates to:
  /// **'Topic deleted successfully'**
  String get topicDeleted;

  /// Topic deletion error message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete topic'**
  String get deleteTopicFailed;

  /// Update topic button
  ///
  /// In en, this message translates to:
  /// **'Update Topic'**
  String get updateTopic;

  /// Topic update success message
  ///
  /// In en, this message translates to:
  /// **'Topic updated successfully'**
  String get topicUpdated;

  /// Topic update error message
  ///
  /// In en, this message translates to:
  /// **'Failed to update topic'**
  String get updateTopicFailed;

  /// Manage accounts page title
  ///
  /// In en, this message translates to:
  /// **'Manage Accounts'**
  String get manageAccounts;

  /// Error message when loading users fails
  ///
  /// In en, this message translates to:
  /// **'Error loading users'**
  String get errorLoadingUsers;

  /// Message when no users are found
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// Label for user join date
  ///
  /// In en, this message translates to:
  /// **'Joined on'**
  String get joinedOn;

  /// Change password button
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Error when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Error when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Success message after password change
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// Error message when password change fails
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get changePasswordFailed;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Create user button
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Required field error message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Invalid email error message
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// Success message after user creation
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSuccessfully;

  /// Error message when user creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create user'**
  String get createUserFailed;

  /// Delete user button
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// Delete user confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this user?'**
  String get deleteUserConfirm;

  /// Success message after user deletion
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeletedSuccessfully;

  /// Error message when user deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete user'**
  String get deleteUserFailed;

  /// Change role label
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get changeRole;

  /// Role label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Success message after role change
  ///
  /// In en, this message translates to:
  /// **'Role changed successfully'**
  String get roleChangedSuccessfully;

  /// Error message when role change fails
  ///
  /// In en, this message translates to:
  /// **'Failed to change role'**
  String get changeRoleFailed;

  /// Search users placeholder
  ///
  /// In en, this message translates to:
  /// **'Search users by name, email or role...'**
  String get searchUsers;

  /// Login page welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Alignify'**
  String get welcomeToConsensusHub;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account to share your insights'**
  String get signInToAccount;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Email field placeholder
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailPlaceholder;

  /// Email field helper text
  ///
  /// In en, this message translates to:
  /// **'Tip: Use admin@endress.com for admin view'**
  String get emailHelperText;

  /// Password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordPlaceholder;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Email required error
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Password required error
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String loginFailed(String error);

  /// Access denied title
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No permission message
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access this content.'**
  String get noPermission;

  /// Go to dashboard button
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// Topic not found error
  ///
  /// In en, this message translates to:
  /// **'Topic not found'**
  String get topicNotFound;

  /// Failed to load topic error
  ///
  /// In en, this message translates to:
  /// **'Failed to load topic: {error}'**
  String failedToLoadTopic(String error);

  /// Idea submitted success message
  ///
  /// In en, this message translates to:
  /// **'Idea submitted successfully!'**
  String get ideaSubmittedSuccessfully;

  /// Failed to submit idea error
  ///
  /// In en, this message translates to:
  /// **'Failed to submit idea: {error}'**
  String failedToSubmitIdea(String error);

  /// Share idea title
  ///
  /// In en, this message translates to:
  /// **'Share Your Idea'**
  String get shareYourIdea;

  /// Anonymous submissions message
  ///
  /// In en, this message translates to:
  /// **'All submissions are anonymous - your perspective matters!'**
  String get anonymousSubmissions;

  /// Your idea label
  ///
  /// In en, this message translates to:
  /// **'Your Idea'**
  String get yourIdea;

  /// Idea input placeholder
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts, ideas, or concerns... (Be specific and constructive)'**
  String get ideaPlaceholder;

  /// Multiple submissions note
  ///
  /// In en, this message translates to:
  /// **'You can submit multiple ideas. All submissions are anonymous.'**
  String get multipleSubmissionsNote;

  /// Submitting state
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// Submit idea button
  ///
  /// In en, this message translates to:
  /// **'Submit Idea'**
  String get submitIdea;

  /// All ideas title
  ///
  /// In en, this message translates to:
  /// **'All Ideas'**
  String get allIdeas;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No ideas message
  ///
  /// In en, this message translates to:
  /// **'No ideas yet'**
  String get noIdeasYet;

  /// Be first to share message
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your thoughts!'**
  String get beFirstToShare;

  /// Generate AI summary button
  ///
  /// In en, this message translates to:
  /// **'Generate AI Summary'**
  String get generateAiSummary;

  /// Analyzing state for AI summary
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// Message when there are no ideas to analyze
  ///
  /// In en, this message translates to:
  /// **'No ideas to analyze'**
  String get noIdeasToAnalyze;

  /// Time ago format
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String timeAgo(String time);

  /// Time ago label for recent actions
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Days short format
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String daysShort(int count);

  /// Hours short format
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String hoursShort(int count);

  /// Minutes short format
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String minutesShort(int count);

  /// Time separator (at)
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// Time ago suffix
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// Start date label
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// End date label
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// Topic created success message
  ///
  /// In en, this message translates to:
  /// **'Topic created successfully!'**
  String get topicCreatedSuccessfully;

  /// Failed to create topic error
  ///
  /// In en, this message translates to:
  /// **'Failed to create topic: {error}'**
  String failedToCreateTopic(String error);

  /// Discard changes dialog title
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChanges;

  /// Unsaved changes message
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get unsavedChangesMessage;

  /// Continue editing button
  ///
  /// In en, this message translates to:
  /// **'Continue Editing'**
  String get continueEditing;

  /// Discard button
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Create new discussion topic title
  ///
  /// In en, this message translates to:
  /// **'Create a New Discussion Topic'**
  String get createNewDiscussionTopic;

  /// Fill details to start subtitle
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to start a new community discussion'**
  String get fillDetailsToStart;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Title field hint
  ///
  /// In en, this message translates to:
  /// **'Enter a clear and concise title'**
  String get titleHint;

  /// Short description label
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get shortDescription;

  /// Short description hint
  ///
  /// In en, this message translates to:
  /// **'Brief overview of the topic (shown in cards)'**
  String get shortDescriptionHint;

  /// Full description label
  ///
  /// In en, this message translates to:
  /// **'Full Description'**
  String get fullDescription;

  /// Full description hint
  ///
  /// In en, this message translates to:
  /// **'Detailed information about the topic'**
  String get fullDescriptionHint;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Title required error
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// Title min length error
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 3 characters'**
  String get titleMinLength;

  /// Title max length error
  ///
  /// In en, this message translates to:
  /// **'Title must not exceed 255 characters'**
  String get titleMaxLength;

  /// Short description required error
  ///
  /// In en, this message translates to:
  /// **'Short description is required'**
  String get shortDescriptionRequired;

  /// Short description min length error
  ///
  /// In en, this message translates to:
  /// **'Short description must be at least 5 characters'**
  String get shortDescriptionMinLength;

  /// Short description max length error
  ///
  /// In en, this message translates to:
  /// **'Short description must not exceed 500 characters'**
  String get shortDescriptionMaxLength;

  /// Description required error
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// Description min length error
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get descriptionMinLength;

  /// Description max length error
  ///
  /// In en, this message translates to:
  /// **'Description must not exceed 2500 characters'**
  String get descriptionMaxLength;

  /// Start date required error
  ///
  /// In en, this message translates to:
  /// **'Start date is required'**
  String get startDateRequired;

  /// End date required error
  ///
  /// In en, this message translates to:
  /// **'End date is required'**
  String get endDateRequired;

  /// End date after start error
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date'**
  String get endDateAfterStart;

  /// User not authenticated error
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// Topic updated success message
  ///
  /// In en, this message translates to:
  /// **'Topic updated successfully!'**
  String get topicUpdatedSuccessfully;

  /// Failed to update topic error
  ///
  /// In en, this message translates to:
  /// **'Failed to update topic: {error}'**
  String failedToUpdateTopic(String error);

  /// Topic ID not provided error
  ///
  /// In en, this message translates to:
  /// **'Error: Topic ID not provided'**
  String get errorTopicIdNotProvided;

  /// Error loading topic title
  ///
  /// In en, this message translates to:
  /// **'Error Loading Topic'**
  String get errorLoadingTopic;

  /// Back to surveys button
  ///
  /// In en, this message translates to:
  /// **'Back to Surveys'**
  String get backToSurveys;

  /// Detailed description label
  ///
  /// In en, this message translates to:
  /// **'Detailed Description'**
  String get detailedDescription;

  /// Topic opens label
  ///
  /// In en, this message translates to:
  /// **'Topic Opens'**
  String get topicOpens;

  /// Topic closes label
  ///
  /// In en, this message translates to:
  /// **'Topic Closes'**
  String get topicCloses;

  /// Update discussion topic title
  ///
  /// In en, this message translates to:
  /// **'Update Discussion Topic'**
  String get updateDiscussionTopic;

  /// Modify details message
  ///
  /// In en, this message translates to:
  /// **'Modify the details of this discussion topic'**
  String get modifyDetailsMessage;

  /// Go to login button
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// Page not found title
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// Page not found message
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for does not exist.'**
  String get pageNotFoundMessage;

  /// Created by label
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get createdBy;

  /// From date label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// To date label
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// Last updated label
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// Timeline section label
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// Created label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Until date label
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get until;

  /// View topic button
  ///
  /// In en, this message translates to:
  /// **'View Topic'**
  String get viewTopic;

  /// By author prefix
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get by;

  /// Summary section title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// AI-generated summary title
  ///
  /// In en, this message translates to:
  /// **'AI-Generated Summary'**
  String get aiGeneratedSummary;

  /// AI summary description
  ///
  /// In en, this message translates to:
  /// **'Automated analysis of all submitted ideas and patterns'**
  String get automatedAnalysisDesc;

  /// Last updated date label
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdatedDate(String date);

  /// Success message for AI analysis
  ///
  /// In en, this message translates to:
  /// **'AI analysis completed successfully!'**
  String get aiAnalysisCompleted;

  /// Error message for AI analysis failure
  ///
  /// In en, this message translates to:
  /// **'Failed to analyze topic: {error}'**
  String failedToAnalyzeTopic(String error);

  /// Active topics stat label
  ///
  /// In en, this message translates to:
  /// **'Active Topics'**
  String get activeTopics;

  /// Your contributions stat label
  ///
  /// In en, this message translates to:
  /// **'Your Contributions'**
  String get yourContributions;

  /// Total contributions stat label
  ///
  /// In en, this message translates to:
  /// **'Total Contributions'**
  String get totalContributions;

  /// Total participants stat label
  ///
  /// In en, this message translates to:
  /// **'Total Participants'**
  String get totalParticipants;

  /// Most popular topics chart title
  ///
  /// In en, this message translates to:
  /// **'Most Popular Topics'**
  String get mostPopularTopics;

  /// Most popular topics chart subtitle
  ///
  /// In en, this message translates to:
  /// **'Topics with the most contributions'**
  String get topicsWithMostSubmissions;

  /// No data available message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Analytics dashboard title
  ///
  /// In en, this message translates to:
  /// **'Analytics Dashboard'**
  String get analyticsDashboard;

  /// Analytics dashboard subtitle
  ///
  /// In en, this message translates to:
  /// **'Key metrics and insights'**
  String get keyMetricsInsights;

  /// Status distribution chart title
  ///
  /// In en, this message translates to:
  /// **'Topic Status Distribution'**
  String get topicStatusDistribution;

  /// Status distribution chart subtitle
  ///
  /// In en, this message translates to:
  /// **'Overview of topic lifecycle'**
  String get topicLifecycleOverview;

  /// Engagement metrics chart title
  ///
  /// In en, this message translates to:
  /// **'Engagement Overview'**
  String get engagementOverview;

  /// Engagement metrics chart subtitle
  ///
  /// In en, this message translates to:
  /// **'Platform activity metrics'**
  String get platformActivityMetrics;

  /// AI summary coverage metric label
  ///
  /// In en, this message translates to:
  /// **'AI Summary\nCoverage'**
  String get aiSummaryCoverage;

  /// Topic participation metric label
  ///
  /// In en, this message translates to:
  /// **'Topic\nParticipation'**
  String get topicParticipation;

  /// Pending AI summary metric label
  ///
  /// In en, this message translates to:
  /// **'Pending Summary'**
  String get pendingSummary;

  /// Average per topic metric label
  ///
  /// In en, this message translates to:
  /// **'Avg per Topic'**
  String get avgPerTopic;

  /// Activity alerts chart title
  ///
  /// In en, this message translates to:
  /// **'Activity Alerts'**
  String get activityAlerts;

  /// Activity alerts chart subtitle
  ///
  /// In en, this message translates to:
  /// **'Important updates & notifications'**
  String get importantUpdatesNotifications;

  /// New topics alert label
  ///
  /// In en, this message translates to:
  /// **'New Topics'**
  String get newTopics;

  /// Topics created this week
  ///
  /// In en, this message translates to:
  /// **'{count} created this week'**
  String createdThisWeek(int count);

  /// Closing soon alert label
  ///
  /// In en, this message translates to:
  /// **'Closing Soon'**
  String get closingSoon;

  /// Topics ending soon
  ///
  /// In en, this message translates to:
  /// **'{count} topics ending in 3 days'**
  String topicsEndingInDays(int count);

  /// Needs attention alert label
  ///
  /// In en, this message translates to:
  /// **'Needs Attention'**
  String get needsAttention;

  /// Topics with low engagement
  ///
  /// In en, this message translates to:
  /// **'{count} topics with low engagement'**
  String topicsLowEngagement(int count);

  /// Topic analytics section title
  ///
  /// In en, this message translates to:
  /// **'Topic Analytics'**
  String get topicAnalytics;

  /// Topic analytics section subtitle
  ///
  /// In en, this message translates to:
  /// **'Detailed insights and engagement metrics'**
  String get detailedInsightsEngagement;

  /// Refresh button tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Engagement overview card title
  ///
  /// In en, this message translates to:
  /// **'Engagement Overview'**
  String get engagementOverviewTitle;

  /// Engagement overview subtitle
  ///
  /// In en, this message translates to:
  /// **'Key metrics for this topic'**
  String get keyMetricsForTopic;

  /// Total submissions metric
  ///
  /// In en, this message translates to:
  /// **'Total Submissions'**
  String get totalSubmissions;

  /// Average per day metric
  ///
  /// In en, this message translates to:
  /// **'Avg. per Day'**
  String get avgPerDay;

  /// Days active metric
  ///
  /// In en, this message translates to:
  /// **'Days Active'**
  String get daysActive;

  /// AI analysis status
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysis;

  /// Complete status
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Topic progress label
  ///
  /// In en, this message translates to:
  /// **'Topic Progress'**
  String get topicProgress;

  /// Topic ended message
  ///
  /// In en, this message translates to:
  /// **'Topic period has ended'**
  String get topicPeriodEnded;

  /// Days elapsed message
  ///
  /// In en, this message translates to:
  /// **'{active} of {total} days elapsed'**
  String daysElapsed(int active, int total);

  /// Submission timeline chart title
  ///
  /// In en, this message translates to:
  /// **'Submission Timeline'**
  String get submissionTimeline;

  /// Submission timeline subtitle
  ///
  /// In en, this message translates to:
  /// **'Daily submission activity over time'**
  String get dailySubmissionActivity;

  /// No submission data message
  ///
  /// In en, this message translates to:
  /// **'No submission data yet'**
  String get noSubmissionData;

  /// Peak value label
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get peak;

  /// Average value label
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// Total days label
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get totalDays;

  /// Key metrics section title
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get keyMetrics;

  /// Count axis label
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// Participation insights title
  ///
  /// In en, this message translates to:
  /// **'Participation Insights'**
  String get participationInsights;

  /// Participation insights subtitle
  ///
  /// In en, this message translates to:
  /// **'When users engage most'**
  String get whenUsersEngage;

  /// Most active hour label
  ///
  /// In en, this message translates to:
  /// **'Most Active Hour'**
  String get mostActiveHour;

  /// Unique participants label
  ///
  /// In en, this message translates to:
  /// **'Unique Participants'**
  String get uniqueParticipants;

  /// Engagement rate label
  ///
  /// In en, this message translates to:
  /// **'Engagement Rate'**
  String get engagementRate;

  /// Per day format
  ///
  /// In en, this message translates to:
  /// **'{rate}/day'**
  String perDay(String rate);

  /// Activity by day of week title
  ///
  /// In en, this message translates to:
  /// **'Activity by Day of Week'**
  String get activityByDayOfWeek;

  /// Common themes title
  ///
  /// In en, this message translates to:
  /// **'Common Themes'**
  String get commonThemes;

  /// Common themes subtitle
  ///
  /// In en, this message translates to:
  /// **'Most frequent words in submissions'**
  String get mostFrequentWords;

  /// No themes message
  ///
  /// In en, this message translates to:
  /// **'No themes detected yet'**
  String get noThemesDetected;

  /// Word cloud footer info
  ///
  /// In en, this message translates to:
  /// **'Top 10 words (excluding common words)'**
  String get topWordsExcludingCommon;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
