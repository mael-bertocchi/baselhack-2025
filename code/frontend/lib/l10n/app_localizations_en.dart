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

  @override
  String get manageAccounts => 'Manage Accounts';

  @override
  String get errorLoadingUsers => 'Error loading users';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get joinedOn => 'Joined on';

  @override
  String get changePassword => 'Change Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get changePasswordFailed => 'Failed to change password';

  @override
  String get save => 'Save';

  @override
  String get createUser => 'Create User';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get userCreatedSuccessfully => 'User created successfully';

  @override
  String get createUserFailed => 'Failed to create user';

  @override
  String get deleteUser => 'Delete User';

  @override
  String get deleteUserConfirm => 'Are you sure you want to delete this user?';

  @override
  String get userDeletedSuccessfully => 'User deleted successfully';

  @override
  String get deleteUserFailed => 'Failed to delete user';

  @override
  String get changeRole => 'Change Role';

  @override
  String get role => 'Role';

  @override
  String get roleChangedSuccessfully => 'Role changed successfully';

  @override
  String get changeRoleFailed => 'Failed to change role';

  @override
  String get searchUsers => 'Search users by name, email or role...';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get welcomeMessage => 'Share your diverse perspectives and help shape better decisions together';

  @override
  String get activeTopics => 'Active Topics';

  @override
  String get yourContributions => 'Your Contributions';

  @override
  String get totalParticipants => 'Total Participants';

  @override
  String get until => 'Until';

  @override
  String get by => 'By';

  @override
  String get viewTopic => 'View Topic';

  @override
  String get welcomeToConsensusHub => 'Welcome to Consensus Hub';

  @override
  String get signInMessage => 'Sign in to your account to share your insights';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get emailHelperText => 'Tip: Use admin@endress.com for admin view';

  @override
  String get password => 'Password';

  @override
  String get passwordPlaceholder => 'Enter your password';

  @override
  String get signIn => 'Sign In';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String loginFailedMessage(String error) {
    return 'Login failed: $error';
  }

  @override
  String get backToSurveys => 'Back to Surveys';

  @override
  String get createdBy => 'Created by';

  @override
  String get from => 'From';

  @override
  String get to => 'to';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String get activeTopic => 'Active Topic';

  @override
  String get closedTopic => 'Closed Topic';

  @override
  String get scheduledTopic => 'Scheduled Topic';

  @override
  String get archivedTopic => 'Archived Topic';

  @override
  String get summary => 'Summary';

  @override
  String get detailedDescription => 'Detailed Description';

  @override
  String get timeline => 'Timeline';

  @override
  String get topicOpens => 'Topic Opens';

  @override
  String get topicCloses => 'Topic Closes';

  @override
  String get created => 'Created';

  @override
  String get shareYourIdea => 'Share Your Idea';

  @override
  String get anonymousMessage => 'All submissions are anonymous - your perspective matters!';

  @override
  String get yourIdea => 'Your Idea';

  @override
  String get ideaPlaceholder => 'Share your thoughts, ideas, or concerns... (Be specific and constructive)';

  @override
  String get multipleSubmissionsMessage => 'You can submit multiple ideas. All submissions are anonymous.';

  @override
  String get submitIdea => 'Submit Idea';

  @override
  String get submitting => 'Submitting...';

  @override
  String get allIdeas => 'All Ideas';

  @override
  String get noIdeasYet => 'No ideas yet';

  @override
  String get beTheFirst => 'Be the first to share your thoughts!';

  @override
  String get ideaSubmittedSuccess => 'Idea submitted successfully!';

  @override
  String ideaSubmissionFailed(String error) {
    return 'Failed to submit idea: $error';
  }

  @override
  String get topicNotFound => 'Topic not found';

  @override
  String get errorLoadingTopic => 'Error Loading Topic';

  @override
  String get retry => 'Retry';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get createNewTopic => 'Create a New Discussion Topic';

  @override
  String get createTopicSubtitle => 'Fill in the details to start a new community discussion';

  @override
  String get title => 'Title';

  @override
  String get titlePlaceholder => 'Enter a clear and concise title';

  @override
  String get shortDescription => 'Short Description';

  @override
  String get shortDescriptionPlaceholder => 'Brief overview of the topic (shown in cards)';

  @override
  String get fullDescription => 'Full Description';

  @override
  String get fullDescriptionPlaceholder => 'Detailed information about the topic';

  @override
  String get duration => 'Duration';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get topicCreatedSuccess => 'Topic created successfully!';

  @override
  String topicCreationFailed(String error) {
    return 'Failed to create topic: $error';
  }

  @override
  String get discardChanges => 'Discard changes?';

  @override
  String get unsavedChangesMessage => 'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get continueEditing => 'Continue Editing';

  @override
  String get discard => 'Discard';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get titleTooShort => 'Title must be at least 3 characters';

  @override
  String get titleTooLong => 'Title must not exceed 255 characters';

  @override
  String get shortDescriptionRequired => 'Short description is required';

  @override
  String get shortDescriptionTooShort => 'Short description must be at least 5 characters';

  @override
  String get shortDescriptionTooLong => 'Short description must not exceed 500 characters';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get descriptionTooShort => 'Description must be at least 10 characters';

  @override
  String get descriptionTooLong => 'Description must not exceed 2500 characters';

  @override
  String get startDateRequired => 'Start date is required';

  @override
  String get endDateRequired => 'End date is required';

  @override
  String get endDateMustBeAfterStart => 'End date must be after start date';

  @override
  String get updateDiscussionTopic => 'Update Discussion Topic';

  @override
  String get modifyTopicDetails => 'Modify the details of this discussion topic';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String get notFoundNumber => '404';

  @override
  String get pageNotFoundMessage => 'The page you are looking for doesn\'t exist or has been moved.';

  @override
  String get goToDashboard => 'Go to Dashboard';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get noPermissionMessage => 'You do not have permission to access this page.';

  @override
  String get userNotAuthenticated => 'User not authenticated';
}
