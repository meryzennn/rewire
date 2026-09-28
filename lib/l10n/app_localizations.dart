import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('id'),
    Locale('ja'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rewire'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore your brain & take control of your life'**
  String get appSubtitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Journey'**
  String get startJourney;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String level(int level);

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String days(int count);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} Minutes'**
  String minutes(int count);

  /// No description provided for @dayCount.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayCount(int day);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get navMeditation;

  /// No description provided for @navWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get navWorkout;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @cleanStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Clean Streak'**
  String get cleanStreakTitle;

  /// No description provided for @relapseStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Reset'**
  String get relapseStreakTitle;

  /// No description provided for @longestStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Longest: {count} Days'**
  String longestStreakSubtitle(int count);

  /// No description provided for @cleanTodayBanner.
  ///
  /// In en, this message translates to:
  /// **'You stayed clean today! Keep up the focus.'**
  String get cleanTodayBanner;

  /// No description provided for @relapseTodayBanner.
  ///
  /// In en, this message translates to:
  /// **'Relapse recorded today. Rise up again!'**
  String get relapseTodayBanner;

  /// No description provided for @checkinCta.
  ///
  /// In en, this message translates to:
  /// **'Check-in Now'**
  String get checkinCta;

  /// No description provided for @alreadyCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in for today'**
  String get alreadyCheckedIn;

  /// No description provided for @dailyQuestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Quests'**
  String get dailyQuestsTitle;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsTitle;

  /// No description provided for @quickMeditation.
  ///
  /// In en, this message translates to:
  /// **'Quick Meditation'**
  String get quickMeditation;

  /// No description provided for @quickWorkout.
  ///
  /// In en, this message translates to:
  /// **'Quick Workout'**
  String get quickWorkout;

  /// No description provided for @emergencyUrge.
  ///
  /// In en, this message translates to:
  /// **'Panic Button'**
  String get emergencyUrge;

  /// No description provided for @brainEvolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain Evolution'**
  String get brainEvolutionTitle;

  /// No description provided for @brainStageDormant.
  ///
  /// In en, this message translates to:
  /// **'Dormant (Initial Stage)'**
  String get brainStageDormant;

  /// No description provided for @brainStageAwakening.
  ///
  /// In en, this message translates to:
  /// **'Awakening (First Sparks)'**
  String get brainStageAwakening;

  /// No description provided for @brainStageGrowing.
  ///
  /// In en, this message translates to:
  /// **'Growing (Strengthening)'**
  String get brainStageGrowing;

  /// No description provided for @brainStageThriving.
  ///
  /// In en, this message translates to:
  /// **'Thriving (Thriving Network)'**
  String get brainStageThriving;

  /// No description provided for @brainStageTranscendent.
  ///
  /// In en, this message translates to:
  /// **'Transcendent (Rewired)'**
  String get brainStageTranscendent;

  /// No description provided for @checkinTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get checkinTitle;

  /// No description provided for @checkinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How did today go?'**
  String get checkinSubtitle;

  /// No description provided for @checkinClean.
  ///
  /// In en, this message translates to:
  /// **'Clean Day'**
  String get checkinClean;

  /// No description provided for @checkinCleanDesc.
  ///
  /// In en, this message translates to:
  /// **'I stayed strong and clean without PMO today.'**
  String get checkinCleanDesc;

  /// No description provided for @checkinRelapse.
  ///
  /// In en, this message translates to:
  /// **'I Relapsed'**
  String get checkinRelapse;

  /// No description provided for @checkinRelapseDesc.
  ///
  /// In en, this message translates to:
  /// **'I stumbled today, but I am ready to get back up.'**
  String get checkinRelapseDesc;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @moodVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Very Bad'**
  String get moodVeryBad;

  /// No description provided for @moodBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get moodBad;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get moodNeutral;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get moodVeryGood;

  /// No description provided for @triggersTitle.
  ///
  /// In en, this message translates to:
  /// **'What were the triggers today?'**
  String get triggersTitle;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes & Reflections'**
  String get notesTitle;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Write down what you learned or how you feel...'**
  String get notesHint;

  /// No description provided for @submitCheckin.
  ///
  /// In en, this message translates to:
  /// **'Save Check-in'**
  String get submitCheckin;

  /// No description provided for @updateCheckin.
  ///
  /// In en, this message translates to:
  /// **'Update Check-in'**
  String get updateCheckin;

  /// No description provided for @meditationTitle.
  ///
  /// In en, this message translates to:
  /// **'Meditation Hub'**
  String get meditationTitle;

  /// No description provided for @meditationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calm your mind and master your urges'**
  String get meditationSubtitle;

  /// No description provided for @selectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select Duration'**
  String get selectDuration;

  /// No description provided for @soundscapeTitle.
  ///
  /// In en, this message translates to:
  /// **'Soundscape'**
  String get soundscapeTitle;

  /// No description provided for @breathingTechnique.
  ///
  /// In en, this message translates to:
  /// **'Breathing Technique'**
  String get breathingTechnique;

  /// No description provided for @startMeditation.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startMeditation;

  /// No description provided for @meditationComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Completed!'**
  String get meditationComplete;

  /// No description provided for @totalMeditationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Total Meditation'**
  String get totalMeditationMinutes;

  /// No description provided for @workoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Physical Workout'**
  String get workoutTitle;

  /// No description provided for @workoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Channel your energy into positive action'**
  String get workoutSubtitle;

  /// No description provided for @allRoutines.
  ///
  /// In en, this message translates to:
  /// **'All Routines'**
  String get allRoutines;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// No description provided for @workoutComplete.
  ///
  /// In en, this message translates to:
  /// **'Workout Completed!'**
  String get workoutComplete;

  /// No description provided for @totalWorkoutMinutes.
  ///
  /// In en, this message translates to:
  /// **'Total Workout'**
  String get totalWorkoutMinutes;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress & Achievements'**
  String get progressTitle;

  /// No description provided for @streakSummary.
  ///
  /// In en, this message translates to:
  /// **'Streak Summary'**
  String get streakSummary;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @unlockedCount.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} of {total} Unlocked'**
  String unlockedCount(int unlocked, int total);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get editName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @physicalData.
  ///
  /// In en, this message translates to:
  /// **'PHYSICAL DATA'**
  String get physicalData;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @darkModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeTitle;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get darkModeSubtitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @dailyReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminderTitle;

  /// No description provided for @meditationReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Meditation Reminder'**
  String get meditationReminderTitle;

  /// No description provided for @workoutReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Reminder'**
  String get workoutReminderTitle;

  /// No description provided for @dataSection.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataSection;

  /// No description provided for @resetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetDataTitle;

  /// No description provided for @resetDataConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data?'**
  String get resetDataConfirmTitle;

  /// No description provided for @resetDataConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently delete all your progress, streaks, and workout history. You will be returned to onboarding.'**
  String get resetDataConfirmContent;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'id', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
