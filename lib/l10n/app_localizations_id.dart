// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Rewire';

  @override
  String get appSubtitle => 'Pulihkan Otak & Kendalikan Hidupmu';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get reset => 'Reset';

  @override
  String get close => 'Tutup';

  @override
  String get continueAction => 'Lanjutkan';

  @override
  String get next => 'Selanjutnya';

  @override
  String get skip => 'Lewati';

  @override
  String get startJourney => 'Mulai Perjalanan';

  @override
  String level(int level) {
    return 'Level $level';
  }

  @override
  String days(int count) {
    return '$count Hari';
  }

  @override
  String minutes(int count) {
    return '$count Menit';
  }

  @override
  String dayCount(int day) {
    return 'Hari ke-$day';
  }

  @override
  String get navHome => 'Beranda';

  @override
  String get navMeditation => 'Meditasi';

  @override
  String get navWorkout => 'Latihan';

  @override
  String get navProgress => 'Progres';

  @override
  String get navProfile => 'Profil';

  @override
  String get cleanStreakTitle => 'Streak Bersih';

  @override
  String get relapseStreakTitle => 'Streak Direset';

  @override
  String longestStreakSubtitle(int count) {
    return 'Terpanjang: $count Hari';
  }

  @override
  String get cleanTodayBanner => 'Kamu bersih hari ini! Pertahankan fokusmu.';

  @override
  String get relapseTodayBanner => 'Hari ini tercatat relapse. Bangkit lagi!';

  @override
  String get checkinCta => 'Check-in Sekarang';

  @override
  String get alreadyCheckedIn => 'Sudah check-in hari ini';

  @override
  String get dailyQuestsTitle => 'Misi Harian';

  @override
  String get quickActionsTitle => 'Aksi Cepat';

  @override
  String get quickMeditation => 'Meditasi Cepat';

  @override
  String get quickWorkout => 'Latihan Cepat';

  @override
  String get emergencyUrge => 'Tombol Panik';

  @override
  String get brainEvolutionTitle => 'Evolusi Otak';

  @override
  String get brainStageDormant => 'Dormant (Tahap Awal)';

  @override
  String get brainStageAwakening => 'Awakening (Mulai Sadar)';

  @override
  String get brainStageGrowing => 'Growing (Bertumbuh)';

  @override
  String get brainStageThriving => 'Thriving (Berkembang)';

  @override
  String get brainStageTranscendent => 'Transcendent (Tertinggi)';

  @override
  String get checkinTitle => 'Check-in Harian';

  @override
  String get checkinSubtitle => 'Bagaimana keadaanmu hari ini?';

  @override
  String get checkinClean => 'Hari Bersih';

  @override
  String get checkinCleanDesc => 'Saya berhasil melewati hari ini tanpa PMO.';

  @override
  String get checkinRelapse => 'Saya Relapse';

  @override
  String get checkinRelapseDesc =>
      'Saya tergelincir, tapi saya siap bangkit kembali.';

  @override
  String get howAreYouFeeling => 'Bagaimana perasaanmu?';

  @override
  String get moodVeryBad => 'Sangat Buruk';

  @override
  String get moodBad => 'Buruk';

  @override
  String get moodNeutral => 'Biasa Saja';

  @override
  String get moodGood => 'Baik';

  @override
  String get moodVeryGood => 'Sangat Baik';

  @override
  String get triggersTitle => 'Apa yang menjadi pemicu (trigger) hari ini?';

  @override
  String get notesTitle => 'Catatan / Refleksi Hari Ini';

  @override
  String get notesHint => 'Tuliskan apa yang kamu pelajari atau rasakan...';

  @override
  String get submitCheckin => 'Simpan Check-in';

  @override
  String get updateCheckin => 'Perbarui Check-in';

  @override
  String get meditationTitle => 'Pusat Meditasi';

  @override
  String get meditationSubtitle => 'Tenangkan pikiran dan kendalikan dorongan';

  @override
  String get selectDuration => 'Pilih Durasi';

  @override
  String get soundscapeTitle => 'Suara Latar';

  @override
  String get breathingTechnique => 'Teknik Pernapasan';

  @override
  String get startMeditation => 'Mulai Sesi';

  @override
  String get meditationComplete => 'Sesi Selesai!';

  @override
  String get totalMeditationMinutes => 'Total Meditasi';

  @override
  String get workoutTitle => 'Latihan Fisik';

  @override
  String get workoutSubtitle => 'Salurkan energimu ke aktivitas positif';

  @override
  String get allRoutines => 'Semua Latihan';

  @override
  String get startWorkout => 'Mulai Latihan';

  @override
  String get workoutComplete => 'Latihan Selesai!';

  @override
  String get totalWorkoutMinutes => 'Total Latihan';

  @override
  String get progressTitle => 'Progres & Pencapaian';

  @override
  String get streakSummary => 'Ringkasan Streak';

  @override
  String get achievementsTitle => 'Pencapaian (Badges)';

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked dari $total Terbuka';
  }

  @override
  String get profileTitle => 'Profil & Pengaturan';

  @override
  String get editProfile => 'Edit Profil';

  @override
  String get editName => 'Ubah Nama';

  @override
  String get fullName => 'Nama Lengkap';

  @override
  String get physicalData => 'DATA FISIK';

  @override
  String get ageLabel => 'Usia';

  @override
  String get heightLabel => 'Tinggi';

  @override
  String get weightLabel => 'Berat';

  @override
  String get appearanceSection => 'Tampilan';

  @override
  String get darkModeTitle => 'Mode Gelap';

  @override
  String get darkModeSubtitle => 'Ubah ke tema gelap';

  @override
  String get languageTitle => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get notificationsSection => 'Notifikasi';

  @override
  String get dailyReminderTitle => 'Pengingat Harian';

  @override
  String get meditationReminderTitle => 'Pengingat Meditasi';

  @override
  String get workoutReminderTitle => 'Pengingat Olahraga';

  @override
  String get dataSection => 'Data';

  @override
  String get resetDataTitle => 'Reset Semua Data';

  @override
  String get resetDataConfirmTitle => 'Reset Semua Data?';

  @override
  String get resetDataConfirmContent =>
      'Tindakan ini akan menghapus semua progres, streak, dan riwayat latihan. Kamu akan dikembalikan ke onboarding. Tindakan ini tidak bisa dibatalkan.';

  @override
  String get aboutSection => 'Tentang';

  @override
  String get appVersion => 'Versi Aplikasi';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get reminderTimeTitle => 'Waktu Pengingat';

  @override
  String get editAction => 'Ubah';

  @override
  String get yearsShort => 'Thn';

  @override
  String get editPhysicalDataTitle => 'Edit Profil & Data Fisik';

  @override
  String get saveChanges => 'Simpan Perubahan';

  @override
  String get streakHistoryTitle => 'Streak History';

  @override
  String get last7Days => '7 Hari Terakhir';

  @override
  String get noData => 'Tidak ada data';

  @override
  String get cleanTag => 'Bersih (Clean)';

  @override
  String get relapseTag => 'Relapse';

  @override
  String get moodTrendTitle => 'Tren Suasana Hati';

  @override
  String get scale1To5 => 'Skala 1 - 5';

  @override
  String get noMoodHistory => 'Belum ada catatan suasana hati 7 hari terakhir';

  @override
  String get mindStatsTitle => 'Statistik Pikiran';

  @override
  String get autoUpdated => 'Pembaruan otomatis';

  @override
  String get currentStreakTitle => 'Streak Saat Ini';

  @override
  String get longestStreakTitle => 'Streak Terpanjang';

  @override
  String get totalCleanDays => 'Total Hari Clean';

  @override
  String get totalMeditation => 'Total Meditasi';

  @override
  String get totalWorkoutSessions => 'Total Workout';

  @override
  String get totalXpAccumulated => 'Total Akumulasi';

  @override
  String sessionsCount(int count) {
    return '$count Sesi';
  }

  @override
  String get weeklyChallengesTitle => 'Tantangan Mingguan';

  @override
  String get calmMindTitle => 'Tenangkan Pikiran';

  @override
  String get calmMindSubtitle =>
      'Pilih suasana dan durasi meditasimu untuk merestorasi fokus hari ini.';

  @override
  String get durationTitle => 'Durasi';

  @override
  String get focusTimeSubtitle => 'Waktu fokus';

  @override
  String get customDuration => 'Kustom ⏱️';

  @override
  String get routinesTitle => 'Rutinitas';

  @override
  String get exercisesTitle => 'Gerakan';

  @override
  String get totalSessions => 'Total Sesi';

  @override
  String get totalMinutesLabel => 'Total Menit';

  @override
  String get seeAll => 'Lihat Semua';

  @override
  String get allFilter => 'Semua';

  @override
  String get workoutXpRewardSubtitle => '+35 XP tiap sesi selesai';

  @override
  String exercisesCount(int count) {
    return '$count Gerakan';
  }

  @override
  String get repsShort => 'Repetisi';

  @override
  String get secondsShort => 'detik';

  @override
  String get targetSet => 'Target Set';

  @override
  String setsCount(int count) {
    return '$count Set';
  }

  @override
  String get durationPerSet => 'Durasi / Set';

  @override
  String get targetPerSet => 'Target / Set';

  @override
  String get targetMusclesTitle => 'Target Otot Utama';

  @override
  String get instructionsTitle => 'Instruksi';

  @override
  String get recoveryTipsTitle => 'Tips Pemulihan & Postur';

  @override
  String get recoveryTipsContent =>
      'Fokus pada pernapasan teratur dan kendalikan setiap repetisi. Gerakan lambat dan presisi lebih efektif mengaktifkan jalur saraf positif dibanding kecepatan.';

  @override
  String get timeBadge => 'Waktu';

  @override
  String get cleanStreakActive => 'Streak Berjalan';

  @override
  String get streakStartFresh => 'Mulai Baru';

  @override
  String get cleanSubtitle => 'bersih tanpa distraksi';

  @override
  String get recoverySubtitle => 'langkah pemulihan';

  @override
  String get alreadyCheckedInToday => 'Kamu sudah check-in hari ini';

  @override
  String get alreadyCheckedInDesc =>
      'Data check-in hari ini sudah tersimpan. Kamu bisa memperbarui data jika kondisi berubah di malam hari (seperti mood atau jika terjadi relapse).';

  @override
  String get selectOne => 'Pilih salah satu';

  @override
  String get optionalLabel => 'Opsional';

  @override
  String get triggersRelapseTitle => 'Pemicu (trigger) relapse?';

  @override
  String get notesEvaluationTitle => 'Catatan Evaluasi (Opsional)';

  @override
  String get notesGratitudeTitle => 'Catatan & Rasa Syukur Hari Ini (Opsional)';

  @override
  String get hintRelapseNotes =>
      'Tulis apa yang memicu relapse atau hal yang bisa dipelajari...';

  @override
  String get hintCleanNotes =>
      'Tulis hal positif atau rasa syukur yang membantumu tetap bersih...';

  @override
  String get checkinSuccessSaved => 'Check-in berhasil disimpan!';

  @override
  String get checkinSuccessUpdated => 'Check-in berhasil diperbarui!';

  @override
  String get checkinEncourageTitle => 'Tidak apa-apa.';

  @override
  String get checkinEncourageDesc =>
      'Setiap proses butuh waktu. Yang terpenting adalah keberanianmu untuk jujur dan bangkit kembali.';

  @override
  String get checkinEncourageStreakNotice =>
      'Streak kamu akan direset, tapi total XP dan level tetap tersimpan utuh.';

  @override
  String get startAgainAction => 'Mulai Lagi 💪';

  @override
  String get checkinBottomMotto =>
      'Satu langkah kecil sadar untuk membentuk jalur otak yang baru.';

  @override
  String get unlockedBadge => 'Terbuka';

  @override
  String get lockedBadge => 'Terkunci';

  @override
  String get noAchievementsYet => 'Belum ada data pencapaian';

  @override
  String get xpProgressTitle => 'Pengalaman Jiwa';

  @override
  String xpToNextLevel(int xp, int nextLevel) {
    return '$xp XP lagi menuju Level $nextLevel';
  }

  @override
  String get maxLevelReached => 'Level Maksimal Tercapai! 🌟';

  @override
  String get cleanDayLegend => 'Hari Bersih';

  @override
  String get relapseDayLegend => 'Hari Relapse';

  @override
  String get brainRewiringProgress => 'Progres Pemulihan Otak';

  @override
  String maxLevelWithXp(int xp) {
    return 'Level Maksimal ($xp XP)';
  }

  @override
  String get brainEvolutionStagesTitle =>
      'Tahapan Evolusi Otak (Neuroplastisitas)';

  @override
  String get freeBreathingTitle => 'Bebas';

  @override
  String get naturalBreathingSubtitle => 'Alami';

  @override
  String get chooseSoundscapeSubtitle => 'Pilih 1 Suasana';

  @override
  String get focusAndBreatheNaturally => 'Fokus & Bernapas Alami';
}
