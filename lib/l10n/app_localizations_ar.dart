// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Rewire';

  @override
  String get appSubtitle => 'استعد صفاء عقلك وتحكم في حياتك';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get close => 'إغلاق';

  @override
  String get continueAction => 'متابعة';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get startJourney => 'ابدأ الرحلة';

  @override
  String level(int level) {
    return 'المستوى $level';
  }

  @override
  String days(int count) {
    return '$count أيام';
  }

  @override
  String minutes(int count) {
    return '$count دقائق';
  }

  @override
  String dayCount(int day) {
    return 'اليوم $day';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navMeditation => 'التأمل';

  @override
  String get navWorkout => 'التمارين';

  @override
  String get navProgress => 'التقدم';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get cleanStreakTitle => 'أيام التعافي';

  @override
  String get relapseStreakTitle => 'تمت إعادة التعيين';

  @override
  String longestStreakSubtitle(int count) {
    return 'الأطول: $count أيام';
  }

  @override
  String get cleanTodayBanner =>
      'لقد حافظت على تعافيك اليوم! استمر في التركيز.';

  @override
  String get relapseTodayBanner => 'تم تسجيل انتكاسة اليوم. انهض من جديد!';

  @override
  String get checkinCta => 'تسجيل الآن';

  @override
  String get alreadyCheckedIn => 'تم التسجيل لهذا اليوم';

  @override
  String get dailyQuestsTitle => 'المهام اليومية';

  @override
  String get quickActionsTitle => 'إجراءات سريعة';

  @override
  String get quickMeditation => 'تأمل سريع';

  @override
  String get quickWorkout => 'تمرين سريع';

  @override
  String get emergencyUrge => 'زر الطوارئ';

  @override
  String get brainEvolutionTitle => 'تطور الدماغ';

  @override
  String get brainStageDormant => 'خامل (المرحلة الأولى)';

  @override
  String get brainStageAwakening => 'صحوة (بداية التعافي)';

  @override
  String get brainStageGrowing => 'نمو (تقوية المسارات)';

  @override
  String get brainStageThriving => 'ازدهار (شبكة عصبية قوية)';

  @override
  String get brainStageTranscendent => 'ارتقاء (إعادة بناء الدماغ)';

  @override
  String get checkinTitle => 'التسجيل اليومي';

  @override
  String get checkinSubtitle => 'كيف كان يومك؟';

  @override
  String get checkinClean => 'يوم نظيف';

  @override
  String get checkinCleanDesc => 'لقد صمدت اليوم بنجاح بدون انتكاسة.';

  @override
  String get checkinRelapse => 'حدثت انتكاسة';

  @override
  String get checkinRelapseDesc =>
      'تعثرت اليوم، لكنني جاهز للنهوض والبدء من جديد.';

  @override
  String get howAreYouFeeling => 'كيف تشعر اليوم؟';

  @override
  String get moodVeryBad => 'سيء جداً';

  @override
  String get moodBad => 'سيء';

  @override
  String get moodNeutral => 'عادي';

  @override
  String get moodGood => 'جيد';

  @override
  String get moodVeryGood => 'ممتاز';

  @override
  String get triggersTitle => 'ما هي المحفزات التي واجهتها اليوم؟';

  @override
  String get notesTitle => 'ملاحظات وتأملات';

  @override
  String get notesHint => 'اكتب ما تعلمته أو ما تشعر به اليوم...';

  @override
  String get submitCheckin => 'حفظ التسجيل';

  @override
  String get updateCheckin => 'تحديث التسجيل';

  @override
  String get meditationTitle => 'مركز التأمل';

  @override
  String get meditationSubtitle => 'هدئ عقلك وتحكم في رغباتك';

  @override
  String get selectDuration => 'اختر المدة';

  @override
  String get soundscapeTitle => 'أصوات الطبيعة';

  @override
  String get breathingTechnique => 'تقنية التنفس';

  @override
  String get startMeditation => 'ابدأ الجلسة';

  @override
  String get meditationComplete => 'اكتملت الجلسة!';

  @override
  String get totalMeditationMinutes => 'إجمالي التأمل';

  @override
  String get workoutTitle => 'التمارين الرياضية';

  @override
  String get workoutSubtitle => 'وجه طاقتك نحو نشاط بدني إيجابي';

  @override
  String get allRoutines => 'جميع التمارين';

  @override
  String get startWorkout => 'ابدأ التمرين';

  @override
  String get workoutComplete => 'اكتمل التمرين!';

  @override
  String get totalWorkoutMinutes => 'إجمالي التمارين';

  @override
  String get progressTitle => 'التقدم والإنجازات';

  @override
  String get streakSummary => 'ملخص الأيام';

  @override
  String get achievementsTitle => 'الأوسمة والإنجازات';

  @override
  String unlockedCount(int unlocked, int total) {
    return 'تم فتح $unlocked من $total';
  }

  @override
  String get profileTitle => 'الملف والإعدادات';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get editName => 'تعديل الاسم';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get physicalData => 'البيانات البدنية';

  @override
  String get ageLabel => 'العمر';

  @override
  String get heightLabel => 'الطول';

  @override
  String get weightLabel => 'الوزن';

  @override
  String get appearanceSection => 'المظهر';

  @override
  String get darkModeTitle => 'الوضع الداكن';

  @override
  String get darkModeSubtitle => 'التبديل إلى المظهر الداكن';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get notificationsSection => 'الإشعارات';

  @override
  String get dailyReminderTitle => 'تذكير يومي';

  @override
  String get meditationReminderTitle => 'تذكير التأمل';

  @override
  String get workoutReminderTitle => 'تذكير التمارين';

  @override
  String get dataSection => 'البيانات';

  @override
  String get resetDataTitle => 'إعادة تعيين كافة البيانات';

  @override
  String get resetDataConfirmTitle => 'هل تريد إعادة تعيين كافة البيانات؟';

  @override
  String get resetDataConfirmContent =>
      'سيؤدي هذا إلى مسح كافة البيانات وسجلات التقدم نهائياً وإعادتك إلى شاشة البداية.';

  @override
  String get aboutSection => 'عن التطبيق';

  @override
  String get appVersion => 'إصدار التطبيق';
}
