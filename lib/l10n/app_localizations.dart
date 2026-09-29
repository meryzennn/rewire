import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @reminderTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTimeTitle;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @yearsShort.
  ///
  /// In en, this message translates to:
  /// **'yrs'**
  String get yearsShort;

  /// No description provided for @editPhysicalDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile & Physical Stats'**
  String get editPhysicalDataTitle;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @streakHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak History'**
  String get streakHistoryTitle;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @cleanTag.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get cleanTag;

  /// No description provided for @relapseTag.
  ///
  /// In en, this message translates to:
  /// **'Relapse'**
  String get relapseTag;

  /// No description provided for @moodTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Trend'**
  String get moodTrendTitle;

  /// No description provided for @scale1To5.
  ///
  /// In en, this message translates to:
  /// **'Scale 1 - 5'**
  String get scale1To5;

  /// No description provided for @noMoodHistory.
  ///
  /// In en, this message translates to:
  /// **'No mood records in the past 7 days'**
  String get noMoodHistory;

  /// No description provided for @mindStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mind Stats'**
  String get mindStatsTitle;

  /// No description provided for @autoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Auto-updated'**
  String get autoUpdated;

  /// No description provided for @currentStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreakTitle;

  /// No description provided for @longestStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreakTitle;

  /// No description provided for @totalCleanDays.
  ///
  /// In en, this message translates to:
  /// **'Total Clean Days'**
  String get totalCleanDays;

  /// No description provided for @totalMeditation.
  ///
  /// In en, this message translates to:
  /// **'Total Meditation'**
  String get totalMeditation;

  /// No description provided for @totalWorkoutSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Workout'**
  String get totalWorkoutSessions;

  /// No description provided for @totalXpAccumulated.
  ///
  /// In en, this message translates to:
  /// **'Total Accumulated'**
  String get totalXpAccumulated;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Sessions'**
  String sessionsCount(int count);

  /// No description provided for @weeklyChallengesTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Challenges'**
  String get weeklyChallengesTitle;

  /// No description provided for @calmMindTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm Your Mind'**
  String get calmMindTitle;

  /// No description provided for @calmMindSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your ambient atmosphere and duration to restore focus today.'**
  String get calmMindSubtitle;

  /// No description provided for @durationTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationTitle;

  /// No description provided for @focusTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focus time'**
  String get focusTimeSubtitle;

  /// No description provided for @customDuration.
  ///
  /// In en, this message translates to:
  /// **'Custom ⏱️'**
  String get customDuration;

  /// No description provided for @routinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get routinesTitle;

  /// No description provided for @exercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesTitle;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// No description provided for @totalMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Minutes'**
  String get totalMinutesLabel;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @workoutXpRewardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'+35 XP per session completed'**
  String get workoutXpRewardSubtitle;

  /// No description provided for @exercisesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Exercises'**
  String exercisesCount(int count);

  /// No description provided for @repsShort.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsShort;

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondsShort;

  /// No description provided for @targetSet.
  ///
  /// In en, this message translates to:
  /// **'Target Sets'**
  String get targetSet;

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Sets'**
  String setsCount(int count);

  /// No description provided for @durationPerSet.
  ///
  /// In en, this message translates to:
  /// **'Duration / Set'**
  String get durationPerSet;

  /// No description provided for @targetPerSet.
  ///
  /// In en, this message translates to:
  /// **'Target / Set'**
  String get targetPerSet;

  /// No description provided for @targetMusclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Target Primary Muscles'**
  String get targetMusclesTitle;

  /// No description provided for @instructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructionsTitle;

  /// No description provided for @recoveryTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery & Posture Tips'**
  String get recoveryTipsTitle;

  /// No description provided for @recoveryTipsContent.
  ///
  /// In en, this message translates to:
  /// **'Focus on steady breathing and controlled motion. Slow, precise movements rewire neural pathways far more effectively than rushing.'**
  String get recoveryTipsContent;

  /// No description provided for @timeBadge.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeBadge;

  /// No description provided for @cleanStreakActive.
  ///
  /// In en, this message translates to:
  /// **'Active Streak'**
  String get cleanStreakActive;

  /// No description provided for @streakStartFresh.
  ///
  /// In en, this message translates to:
  /// **'Fresh Start'**
  String get streakStartFresh;

  /// No description provided for @cleanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'clean without distraction'**
  String get cleanSubtitle;

  /// No description provided for @recoverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'recovery step'**
  String get recoverySubtitle;

  /// No description provided for @alreadyCheckedInToday.
  ///
  /// In en, this message translates to:
  /// **'You already checked in today'**
  String get alreadyCheckedInToday;

  /// No description provided for @alreadyCheckedInDesc.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-in has been saved. You can update it anytime if circumstances change later tonight (such as your mood or a relapse).'**
  String get alreadyCheckedInDesc;

  /// No description provided for @selectOne.
  ///
  /// In en, this message translates to:
  /// **'Select one'**
  String get selectOne;

  /// No description provided for @optionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalLabel;

  /// No description provided for @triggersRelapseTitle.
  ///
  /// In en, this message translates to:
  /// **'What triggered the relapse?'**
  String get triggersRelapseTitle;

  /// No description provided for @notesEvaluationTitle.
  ///
  /// In en, this message translates to:
  /// **'Evaluation Notes (Optional)'**
  String get notesEvaluationTitle;

  /// No description provided for @notesGratitudeTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes & Gratitude Today (Optional)'**
  String get notesGratitudeTitle;

  /// No description provided for @hintRelapseNotes.
  ///
  /// In en, this message translates to:
  /// **'Write what triggered the relapse or what you learned...'**
  String get hintRelapseNotes;

  /// No description provided for @hintCleanNotes.
  ///
  /// In en, this message translates to:
  /// **'Write positive reflections or gratitude that kept you clean...'**
  String get hintCleanNotes;

  /// No description provided for @checkinSuccessSaved.
  ///
  /// In en, this message translates to:
  /// **'Check-in saved successfully!'**
  String get checkinSuccessSaved;

  /// No description provided for @checkinSuccessUpdated.
  ///
  /// In en, this message translates to:
  /// **'Check-in updated successfully!'**
  String get checkinSuccessUpdated;

  /// No description provided for @checkinEncourageTitle.
  ///
  /// In en, this message translates to:
  /// **'It\'s okay.'**
  String get checkinEncourageTitle;

  /// No description provided for @checkinEncourageDesc.
  ///
  /// In en, this message translates to:
  /// **'Every recovery journey takes time. What matters most is your honesty and courage to rise up again.'**
  String get checkinEncourageDesc;

  /// No description provided for @checkinEncourageStreakNotice.
  ///
  /// In en, this message translates to:
  /// **'Your streak will reset, but your total XP and level remain completely intact.'**
  String get checkinEncourageStreakNotice;

  /// No description provided for @startAgainAction.
  ///
  /// In en, this message translates to:
  /// **'Start Again 💪'**
  String get startAgainAction;

  /// No description provided for @checkinBottomMotto.
  ///
  /// In en, this message translates to:
  /// **'One conscious step toward building a newly wired brain.'**
  String get checkinBottomMotto;

  /// No description provided for @unlockedBadge.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlockedBadge;

  /// No description provided for @lockedBadge.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get lockedBadge;

  /// No description provided for @noAchievementsYet.
  ///
  /// In en, this message translates to:
  /// **'No achievement data yet'**
  String get noAchievementsYet;

  /// No description provided for @xpProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'XP Progress'**
  String get xpProgressTitle;

  /// No description provided for @xpToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to Level {nextLevel}'**
  String xpToNextLevel(int xp, int nextLevel);

  /// No description provided for @maxLevelReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum Level Reached! 🌟'**
  String get maxLevelReached;

  /// No description provided for @cleanDayLegend.
  ///
  /// In en, this message translates to:
  /// **'Clean Day'**
  String get cleanDayLegend;

  /// No description provided for @relapseDayLegend.
  ///
  /// In en, this message translates to:
  /// **'Relapse Day'**
  String get relapseDayLegend;

  /// No description provided for @brainRewiringProgress.
  ///
  /// In en, this message translates to:
  /// **'Brain Rewiring Progress'**
  String get brainRewiringProgress;

  /// No description provided for @maxLevelWithXp.
  ///
  /// In en, this message translates to:
  /// **'Max Level ({xp} XP)'**
  String maxLevelWithXp(int xp);

  /// No description provided for @brainEvolutionStagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain Evolution Stages (Neuroplasticity)'**
  String get brainEvolutionStagesTitle;

  /// No description provided for @freeBreathingTitle.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freeBreathingTitle;

  /// No description provided for @naturalBreathingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get naturalBreathingSubtitle;

  /// No description provided for @chooseSoundscapeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose 1 Soundscape'**
  String get chooseSoundscapeSubtitle;

  /// No description provided for @focusAndBreatheNaturally.
  ///
  /// In en, this message translates to:
  /// **'Focus & Breathe Naturally'**
  String get focusAndBreatheNaturally;

  /// No description provided for @cancelWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Workout?'**
  String get cancelWorkoutTitle;

  /// No description provided for @cancelWorkoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Progress from this session will not be saved if you exit now.'**
  String get cancelWorkoutMessage;

  /// No description provided for @continueWorkout.
  ///
  /// In en, this message translates to:
  /// **'Continue Workout'**
  String get continueWorkout;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @exerciseProgress.
  ///
  /// In en, this message translates to:
  /// **'Exercise {current} / {total}'**
  String exerciseProgress(int current, int total);

  /// No description provided for @currentSetProgress.
  ///
  /// In en, this message translates to:
  /// **'Set {current} / {total}'**
  String currentSetProgress(int current, int total);

  /// No description provided for @completeSet.
  ///
  /// In en, this message translates to:
  /// **'Complete Set ✓'**
  String get completeSet;

  /// No description provided for @finishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish Workout ✓'**
  String get finishWorkout;

  /// No description provided for @lastExerciseLabel.
  ///
  /// In en, this message translates to:
  /// **'Final Exercise!'**
  String get lastExerciseLabel;

  /// No description provided for @restTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get restTitle;

  /// No description provided for @skipRest.
  ///
  /// In en, this message translates to:
  /// **'Skip Rest'**
  String get skipRest;

  /// No description provided for @workoutFinishedHeadline.
  ///
  /// In en, this message translates to:
  /// **'Workout Complete! 💪'**
  String get workoutFinishedHeadline;

  /// No description provided for @workoutFinishedSummary.
  ///
  /// In en, this message translates to:
  /// **'{minutes} mins · {count} exercises completed'**
  String workoutFinishedSummary(int minutes, int count);

  /// No description provided for @levelUpNotification.
  ///
  /// In en, this message translates to:
  /// **'Level Up! You reached Level {level}'**
  String levelUpNotification(int level);

  /// No description provided for @startThisExercise.
  ///
  /// In en, this message translates to:
  /// **'Start This Exercise'**
  String get startThisExercise;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @secondsUnit.
  ///
  /// In en, this message translates to:
  /// **'{seconds} Seconds'**
  String secondsUnit(int seconds);

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize Your Journey'**
  String get setupTitle;

  /// No description provided for @continueToApp.
  ///
  /// In en, this message translates to:
  /// **'Continue to App'**
  String get continueToApp;

  /// No description provided for @languageChoice.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageChoice;

  /// No description provided for @birthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthdayLabel;

  /// No description provided for @birthYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Year'**
  String get birthYearLabel;

  /// No description provided for @yearsOldLabel.
  ///
  /// In en, this message translates to:
  /// **'years old'**
  String get yearsOldLabel;

  /// No description provided for @fitnessLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Fitness Level'**
  String get fitnessLevelLabel;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @beginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'New to fitness or returning after a break'**
  String get beginnerDesc;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @intermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'Active regularly and comfortable with bodyweight exercises'**
  String get intermediateDesc;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @expertDesc.
  ///
  /// In en, this message translates to:
  /// **'High strength and endurance training routine'**
  String get expertDesc;

  /// No description provided for @bmiLabel.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmiLabel;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get bmiNormal;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiObese;

  /// No description provided for @jointSafetyWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Joint Safety Caution ⚠️'**
  String get jointSafetyWarningTitle;

  /// No description provided for @jointSafetyWarningDesc.
  ///
  /// In en, this message translates to:
  /// **'This movement puts high impact or full bodyweight pressure on knee, ankle, or shoulder joints. Beginners or individuals with elevated body mass are advised to use low-impact alternatives.'**
  String get jointSafetyWarningDesc;

  /// No description provided for @useSafeAlternative.
  ///
  /// In en, this message translates to:
  /// **'Use Safe Alternative'**
  String get useSafeAlternative;

  /// No description provided for @proceedAnyway.
  ///
  /// In en, this message translates to:
  /// **'Proceed Anyway'**
  String get proceedAnyway;

  /// No description provided for @recommendedAlternativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended Alternative'**
  String get recommendedAlternativeLabel;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rewire'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Start your brain rewiring journey today.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingPillarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Three Pillars of Rewire'**
  String get onboardingPillarsTitle;

  /// No description provided for @onboardingPillarsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your recovery progress, calm your mind with meditation, and move with home workouts.'**
  String get onboardingPillarsDesc;

  /// No description provided for @onboardingLevelUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Level Up Your Brain'**
  String get onboardingLevelUpTitle;

  /// No description provided for @onboardingLevelUpDesc.
  ///
  /// In en, this message translates to:
  /// **'Positive activities earn you XP. As you progress, your brain evolves through five stages.'**
  String get onboardingLevelUpDesc;

  /// No description provided for @onboardingRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Daily Reminders'**
  String get onboardingRemindersTitle;

  /// No description provided for @onboardingRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your daily check-in time. Meditation and workout reminders can also be set later.'**
  String get onboardingRemindersDesc;

  /// No description provided for @onboardingStepSemantics.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingStepSemantics(int current, int total);

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @bodyMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Metrics'**
  String get bodyMetricsTitle;

  /// No description provided for @profileSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSectionTitle;

  /// No description provided for @meditationFinishedHeadline.
  ///
  /// In en, this message translates to:
  /// **'Session Completed! 🧘'**
  String get meditationFinishedHeadline;

  /// No description provided for @meditationFinishedDuration.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min of meditation completed'**
  String meditationFinishedDuration(int minutes);

  /// No description provided for @meditationSessionsCompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min · {sessions} sessions completed'**
  String meditationSessionsCompletedSummary(int minutes, int sessions);

  /// No description provided for @cropPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust Photo'**
  String get cropPhotoTitle;

  /// No description provided for @cropPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Pinch or drag to position and zoom'**
  String get cropPhotoHint;
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
      <String>['en', 'es', 'id', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
