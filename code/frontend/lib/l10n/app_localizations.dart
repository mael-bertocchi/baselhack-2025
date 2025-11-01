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
  /// **'Consensus Hub'**
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
