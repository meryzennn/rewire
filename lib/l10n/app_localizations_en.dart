// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rewire';

  @override
  String get appSubtitle => 'Restore your brain & take control of your life';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset';

  @override
  String get close => 'Close';

  @override
  String get continueAction => 'Continue';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get startJourney => 'Start Journey';

  @override
  String level(int level) {
    return 'Level $level';
  }

  @override
  String days(int count) {
    return '$count Days';
  }

  @override
  String minutes(int count) {
    return '$count Minutes';
  }

  @override
  String dayCount(int day) {
    return 'Day $day';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navMeditation => 'Meditation';

  @override
  String get navWorkout => 'Workout';

  @override
  String get navProgress => 'Progress';

  @override
  String get navProfile => 'Profile';

  @override
  String get cleanStreakTitle => 'Clean Streak';

  @override
  String get relapseStreakTitle => 'Streak Reset';

  @override
  String longestStreakSubtitle(int count) {
    return 'Longest: $count Days';
  }

  @override
  String get cleanTodayBanner => 'You stayed clean today! Keep up the focus.';

  @override
  String get relapseTodayBanner => 'Relapse recorded today. Rise up again!';

  @override
  String get checkinCta => 'Check-in Now';

  @override
  String get alreadyCheckedIn => 'Checked in for today';

  @override
  String get dailyQuestsTitle => 'Daily Quests';

  @override
  String get quickActionsTitle => 'Quick Actions';

  @override
  String get quickMeditation => 'Quick Meditation';

  @override
  String get quickWorkout => 'Quick Workout';

  @override
  String get emergencyUrge => 'Panic Button';

  @override
  String get brainEvolutionTitle => 'Brain Evolution';

  @override
  String get brainStageDormant => 'Dormant (Initial Stage)';

  @override
  String get brainStageAwakening => 'Awakening (First Sparks)';

  @override
  String get brainStageGrowing => 'Growing (Strengthening)';

  @override
  String get brainStageThriving => 'Thriving (Thriving Network)';

  @override
  String get brainStageTranscendent => 'Transcendent (Rewired)';

  @override
  String get checkinTitle => 'Daily Check-in';

  @override
  String get checkinSubtitle => 'How did today go?';

  @override
  String get checkinClean => 'Clean Day';

  @override
  String get checkinCleanDesc => 'I stayed strong and clean without PMO today.';

  @override
  String get checkinRelapse => 'I Relapsed';

  @override
  String get checkinRelapseDesc =>
      'I stumbled today, but I am ready to get back up.';

  @override
  String get howAreYouFeeling => 'How are you feeling?';

  @override
  String get moodVeryBad => 'Very Bad';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodGood => 'Good';

  @override
  String get moodVeryGood => 'Very Good';

  @override
  String get triggersTitle => 'What were the triggers today?';

  @override
  String get notesTitle => 'Notes & Reflections';

  @override
  String get notesHint => 'Write down what you learned or how you feel...';

  @override
  String get submitCheckin => 'Save Check-in';

  @override
  String get updateCheckin => 'Update Check-in';

  @override
  String get meditationTitle => 'Meditation Hub';

  @override
  String get meditationSubtitle => 'Calm your mind and master your urges';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get soundscapeTitle => 'Soundscape';

  @override
  String get breathingTechnique => 'Breathing Technique';

  @override
  String get startMeditation => 'Start Session';

  @override
  String get meditationComplete => 'Session Completed!';

  @override
  String get totalMeditationMinutes => 'Total Meditation';

  @override
  String get workoutTitle => 'Physical Workout';

  @override
  String get workoutSubtitle => 'Channel your energy into positive action';

  @override
  String get allRoutines => 'All Routines';

  @override
  String get startWorkout => 'Start Workout';

  @override
  String get workoutComplete => 'Workout Completed!';

  @override
  String get totalWorkoutMinutes => 'Total Workout';

  @override
  String get progressTitle => 'Progress & Achievements';

  @override
  String get streakSummary => 'Streak Summary';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked of $total Unlocked';
  }

  @override
  String get profileTitle => 'Profile & Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editName => 'Change Name';

  @override
  String get fullName => 'Full Name';

  @override
  String get physicalData => 'PHYSICAL DATA';

  @override
  String get ageLabel => 'Age';

  @override
  String get heightLabel => 'Height';

  @override
  String get weightLabel => 'Weight';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get darkModeTitle => 'Dark Mode';

  @override
  String get darkModeSubtitle => 'Switch to dark theme';

  @override
  String get languageTitle => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get dailyReminderTitle => 'Daily Reminder';

  @override
  String get meditationReminderTitle => 'Meditation Reminder';

  @override
  String get workoutReminderTitle => 'Workout Reminder';

  @override
  String get dataSection => 'Data';

  @override
  String get resetDataTitle => 'Reset All Data';

  @override
  String get resetDataConfirmTitle => 'Reset All Data?';

  @override
  String get resetDataConfirmContent =>
      'This action will permanently delete all your progress, streaks, and workout history. You will be returned to onboarding.';

  @override
  String get aboutSection => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get reminderTimeTitle => 'Reminder Time';

  @override
  String get editAction => 'Edit';

  @override
  String get yearsShort => 'yrs';

  @override
  String get editPhysicalDataTitle => 'Edit Profile & Physical Stats';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get streakHistoryTitle => 'Streak History';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String get noData => 'No data';

  @override
  String get cleanTag => 'Clean';

  @override
  String get relapseTag => 'Relapse';

  @override
  String get moodTrendTitle => 'Mood Trend';

  @override
  String get scale1To5 => 'Scale 1 - 5';

  @override
  String get noMoodHistory => 'No mood records in the past 7 days';

  @override
  String get mindStatsTitle => 'Mind Stats';

  @override
  String get autoUpdated => 'Auto-updated';

  @override
  String get currentStreakTitle => 'Current Streak';

  @override
  String get longestStreakTitle => 'Longest Streak';

  @override
  String get totalCleanDays => 'Total Clean Days';

  @override
  String get totalMeditation => 'Total Meditation';

  @override
  String get totalWorkoutSessions => 'Total Workout';

  @override
  String get totalXpAccumulated => 'Total Accumulated';

  @override
  String sessionsCount(int count) {
    return '$count Sessions';
  }

  @override
  String get weeklyChallengesTitle => 'Weekly Challenges';

  @override
  String get calmMindTitle => 'Calm Your Mind';

  @override
  String get calmMindSubtitle =>
      'Choose your ambient atmosphere and duration to restore focus today.';

  @override
  String get durationTitle => 'Duration';

  @override
  String get focusTimeSubtitle => 'Focus time';

  @override
  String get customDuration => 'Custom ⏱️';

  @override
  String get routinesTitle => 'Routines';

  @override
  String get exercisesTitle => 'Exercises';

  @override
  String get totalSessions => 'Total Sessions';

  @override
  String get totalMinutesLabel => 'Total Minutes';

  @override
  String get seeAll => 'See All';

  @override
  String get allFilter => 'All';

  @override
  String get workoutXpRewardSubtitle => '+35 XP per session completed';

  @override
  String exercisesCount(int count) {
    return '$count Exercises';
  }

  @override
  String get repsShort => 'Reps';

  @override
  String get secondsShort => 's';

  @override
  String get targetSet => 'Target Sets';

  @override
  String setsCount(int count) {
    return '$count Sets';
  }

  @override
  String get durationPerSet => 'Duration / Set';

  @override
  String get targetPerSet => 'Target / Set';

  @override
  String get targetMusclesTitle => 'Target Primary Muscles';

  @override
  String get instructionsTitle => 'Instructions';

  @override
  String get recoveryTipsTitle => 'Recovery & Posture Tips';

  @override
  String get recoveryTipsContent =>
      'Focus on steady breathing and controlled motion. Slow, precise movements rewire neural pathways far more effectively than rushing.';

  @override
  String get timeBadge => 'Time';

  @override
  String get cleanStreakActive => 'Active Streak';

  @override
  String get streakStartFresh => 'Fresh Start';

  @override
  String get cleanSubtitle => 'clean without distraction';

  @override
  String get recoverySubtitle => 'recovery step';

  @override
  String get alreadyCheckedInToday => 'You already checked in today';

  @override
  String get alreadyCheckedInDesc =>
      'Today\'s check-in has been saved. You can update it anytime if circumstances change later tonight (such as your mood or a relapse).';

  @override
  String get selectOne => 'Select one';

  @override
  String get optionalLabel => 'Optional';

  @override
  String get triggersRelapseTitle => 'What triggered the relapse?';

  @override
  String get notesEvaluationTitle => 'Evaluation Notes (Optional)';

  @override
  String get notesGratitudeTitle => 'Notes & Gratitude Today (Optional)';

  @override
  String get hintRelapseNotes =>
      'Write what triggered the relapse or what you learned...';

  @override
  String get hintCleanNotes =>
      'Write positive reflections or gratitude that kept you clean...';

  @override
  String get checkinSuccessSaved => 'Check-in saved successfully!';

  @override
  String get checkinSuccessUpdated => 'Check-in updated successfully!';

  @override
  String get checkinEncourageTitle => 'It\'s okay.';

  @override
  String get checkinEncourageDesc =>
      'Every recovery journey takes time. What matters most is your honesty and courage to rise up again.';

  @override
  String get checkinEncourageStreakNotice =>
      'Your streak will reset, but your total XP and level remain completely intact.';

  @override
  String get startAgainAction => 'Start Again 💪';

  @override
  String get checkinBottomMotto =>
      'One conscious step toward building a newly wired brain.';

  @override
  String get unlockedBadge => 'Unlocked';

  @override
  String get lockedBadge => 'Locked';

  @override
  String get noAchievementsYet => 'No achievement data yet';

  @override
  String get xpProgressTitle => 'XP Progress';

  @override
  String xpToNextLevel(int xp, int nextLevel) {
    return '$xp XP to Level $nextLevel';
  }

  @override
  String get maxLevelReached => 'Maximum Level Reached! 🌟';

  @override
  String get cleanDayLegend => 'Clean Day';

  @override
  String get relapseDayLegend => 'Relapse Day';

  @override
  String get brainRewiringProgress => 'Brain Rewiring Progress';

  @override
  String maxLevelWithXp(int xp) {
    return 'Max Level ($xp XP)';
  }

  @override
  String get brainEvolutionStagesTitle =>
      'Brain Evolution Stages (Neuroplasticity)';

  @override
  String get freeBreathingTitle => 'Free';

  @override
  String get naturalBreathingSubtitle => 'Natural';

  @override
  String get chooseSoundscapeSubtitle => 'Choose 1 Soundscape';

  @override
  String get focusAndBreatheNaturally => 'Focus & Breathe Naturally';

  @override
  String get cancelWorkoutTitle => 'Cancel Workout?';

  @override
  String get cancelWorkoutMessage =>
      'Progress from this session will not be saved if you exit now.';

  @override
  String get continueWorkout => 'Continue Workout';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String exerciseProgress(int current, int total) {
    return 'Exercise $current / $total';
  }

  @override
  String currentSetProgress(int current, int total) {
    return 'Set $current / $total';
  }

  @override
  String get completeSet => 'Complete Set ✓';

  @override
  String get finishWorkout => 'Finish Workout ✓';

  @override
  String get lastExerciseLabel => 'Final Exercise!';

  @override
  String get restTitle => 'Rest';

  @override
  String get skipRest => 'Skip Rest';

  @override
  String get workoutFinishedHeadline => 'Workout Complete! 💪';

  @override
  String workoutFinishedSummary(int minutes, int count) {
    return '$minutes mins · $count exercises completed';
  }

  @override
  String levelUpNotification(int level) {
    return 'Level Up! You reached Level $level';
  }

  @override
  String get startThisExercise => 'Start This Exercise';

  @override
  String get done => 'Done';

  @override
  String secondsUnit(int seconds) {
    return '$seconds Seconds';
  }
}
