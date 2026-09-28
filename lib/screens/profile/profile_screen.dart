import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/provider_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/achievement_provider.dart';
import '../../providers/checkin_provider.dart';
import '../../providers/meditation_provider.dart';
import '../../providers/quest_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/workout_provider.dart';
import '../../services/notification_service.dart';
import '../../services/preference_service.dart';

/// Combined Profile and Settings screen.
///
/// Displays user info (name, avatar, age, height, weight) with image upload
/// validation (png, jpg, jpeg, webp only) and embeds the app settings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.preferences,
    required this.onResetData,
    this.notificationService,
  });

  final PreferenceService preferences;
  final Future<void> Function() onResetData;
  final NotificationService? notificationService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PreferenceService get _prefs => widget.preferences;

  static const _allowedExtensions = ['png', 'jpg', 'jpeg', 'webp'];

  Future<void> _pickProfilePicture() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;

      final fileName = picked.name.toLowerCase();
      final dotIndex = fileName.lastIndexOf('.');
      final ext = dotIndex != -1 ? fileName.substring(dotIndex + 1) : '';

      if (!_allowedExtensions.contains(ext)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Hanya format PNG, JPG, JPEG, dan WEBP yang diperbolehkan untuk foto profil.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final appDir = await getApplicationDocumentsDirectory();
      final targetPath =
          '${appDir.path}/pfp_${DateTime.now().millisecondsSinceEpoch}.$ext';
      await File(picked.path).copy(targetPath);
      await _prefs.setUserPfpPath(targetPath);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _prefs.userName);
    final ageCtrl = TextEditingController(
      text: _prefs.userAge != null ? _prefs.userAge.toString() : '',
    );
    final heightCtrl = TextEditingController(
      text: _prefs.userHeight != null
          ? _prefs.userHeight!.toStringAsFixed(0)
          : '',
    );
    final weightCtrl = TextEditingController(
      text: _prefs.userWeight != null
          ? _prefs.userWeight!.toStringAsFixed(0)
          : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profil & Data Fisik',
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                key: const Key('input-profile-name'),
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama kamu',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('input-profile-age'),
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Umur (tahun)',
                  hintText: 'Contoh: 24',
                  prefixIcon: Icon(Icons.cake_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('input-profile-height'),
                      controller: heightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Tinggi Badan (cm)',
                        hintText: '170',
                        prefixIcon: Icon(Icons.height_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      key: const Key('input-profile-weight'),
                      controller: weightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Berat Badan (kg)',
                        hintText: '65',
                        prefixIcon: Icon(Icons.monitor_weight_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('btn-save-profile'),
                onPressed: () async {
                  await _prefs.setUserName(nameCtrl.text.trim());
                  final age = int.tryParse(ageCtrl.text.trim());
                  await _prefs.setUserAge(age);
                  final height = double.tryParse(heightCtrl.text.trim());
                  await _prefs.setUserHeight(height);
                  final weight = double.tryParse(weightCtrl.text.trim());
                  await _prefs.setUserWeight(weight);
                  if (mounted) setState(() {});
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditNameDialog() {
    final nameCtrl = TextEditingController(text: _prefs.userName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Nama'),
        content: TextField(
          key: const Key('input-edit-name'),
          controller: nameCtrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nama Lengkap',
            hintText: 'Masukkan nama kamu',
            prefixIcon: Icon(Icons.person_outline_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            key: const Key('btn-save-name'),
            onPressed: () async {
              await _prefs.setUserName(nameCtrl.text.trim());
              if (mounted) setState(() {});
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  String _currentLanguageLabel(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'ja':
        return '日本語';
      case 'id':
      default:
        return 'Bahasa Indonesia';
    }
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final currentLang = _prefs.language;
        final theme = Theme.of(sheetContext);
        const languages = [
          ('id', 'Bahasa Indonesia', '🇮🇩'),
          ('en', 'English', '🇺🇸'),
          ('es', 'Español', '🇪🇸'),
          ('ja', '日本語', '🇯🇵'),
        ];

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Text(
                    'Pilih Bahasa / Select Language',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                for (final (code, name, flag) in languages)
                  ListTile(
                    key: Key('lang-option-$code'),
                    leading: Text(flag, style: const TextStyle(fontSize: 24)),
                    title: Text(name),
                    trailing: currentLang == code
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () async {
                      await _prefs.setLanguage(code);
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
                      if (mounted) setState(() {});
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _cachedPfpPath;
  bool _pfpFileExists = false;

  void _checkPfpFile() {
    final path = _prefs.userPfpPath;
    if (path != _cachedPfpPath) {
      _cachedPfpPath = path;
      _pfpFileExists = path != null && File(path).existsSync();
    }
  }

  Widget _buildAvatarHeader(BuildContext context) {
    final theme = Theme.of(context);
    _checkPfpFile();
    final pfpPath = _cachedPfpPath;
    final hasValidFile = _pfpFileExists && pfpPath != null;

    final userProvider = context.watch<UserProvider?>();
    final level = userProvider?.level ?? 1;
    final streak = userProvider?.currentStreak ?? 0;
    final displayName = _prefs.userName.isNotEmpty
        ? _prefs.userName
        : 'Pejuang Rewire';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primaryContainer,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage:
                      hasValidFile ? FileImage(File(pfpPath)) : null,
                  child: hasValidFile
                      ? null
                      : Icon(
                          Icons.person_rounded,
                          size: 52,
                          color: theme.colorScheme.primary,
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: theme.colorScheme.primary,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: InkWell(
                    key: const Key('btn-change-pfp'),
                    customBorder: const CircleBorder(),
                    onTap: _pickProfilePicture,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            key: const Key('btn-edit-name'),
            onTap: _showEditNameDialog,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      displayName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.edit_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)?.level(level) ?? 'Level $level',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)?.days(streak) ?? '$streak Hari',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalStatsCard(BuildContext context) {
    final theme = Theme.of(context);
    final ageText =
        _prefs.userAge != null ? '${_prefs.userAge} Thn' : '-';
    final heightText =
        _prefs.userHeight != null ? '${_prefs.userHeight!.toStringAsFixed(0)} cm' : '-';
    final weightText =
        _prefs.userWeight != null ? '${_prefs.userWeight!.toStringAsFixed(0)} kg' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.physicalData ?? 'DATA FISIK',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: theme.colorScheme.primary,
                ),
              ),
              InkWell(
                key: const Key('btn-edit-profile'),
                onTap: _showEditProfileDialog,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ubah',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatMetric(
                  icon: Icons.cake_outlined,
                  value: ageText,
                  label: 'Umur',
                ),
              ),
              Container(
                height: 36,
                width: 1,
                color: theme.dividerColor.withValues(alpha: 0.6),
              ),
              Expanded(
                child: _StatMetric(
                  icon: Icons.height_rounded,
                  value: heightText,
                  label: 'Tinggi',
                ),
              ),
              Container(
                height: 36,
                width: 1,
                color: theme.dividerColor.withValues(alpha: 0.6),
              ),
              Expanded(
                child: _StatMetric(
                  icon: Icons.monitor_weight_outlined,
                  value: weightText,
                  label: 'Berat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      key: const Key('screen-settings'),
      appBar: AppBar(
        title: Text(l10n?.navProfile ?? 'Profil'),
      ),
      body: AnimatedBuilder(
        animation: _prefs,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatarHeader(context),
              _buildPhysicalStatsCard(context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  l10n?.settingsTitle ?? 'Pengaturan',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _Section(
                title: l10n?.appearanceSection ?? 'Tampilan',
                children: [
                  _SwitchRow(
                    switchKey: const Key('toggle-dark-mode'),
                    icon: Icons.dark_mode_rounded,
                    tint: _Tint.secondary,
                    title: l10n?.darkModeTitle ?? 'Mode Gelap',
                    subtitle: l10n?.darkModeSubtitle ?? 'Ubah ke tema gelap',
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: _prefs.setDarkMode,
                  ),
                  _NavRow(
                    rowKey: const Key('row-select-language'),
                    icon: Icons.language_rounded,
                    tint: _Tint.primary,
                    title: l10n?.languageTitle ?? 'Bahasa',
                    trailing: _currentLanguageLabel(_prefs.language),
                    onTap: _showLanguageSelector,
                  ),
                ],
              ),
              _Section(
                title: l10n?.notificationsSection ?? 'Notifikasi',
                children: [
                  _SwitchRow(
                    switchKey: const Key('toggle-daily-reminder'),
                    icon: Icons.notifications_rounded,
                    tint: _Tint.primary,
                    title: l10n?.dailyReminderTitle ?? 'Pengingat Harian',
                    value: _prefs.dailyReminderEnabled,
                    onChanged: (val) async {
                      await _prefs.setDailyReminderEnabled(val);
                      if (val) {
                        await widget.notificationService?.requestPermission();
                        await widget.notificationService?.scheduleDailyReminder(
                          NotificationService.parseHhmm(
                            _prefs.dailyReminderTime,
                          ),
                        );
                      } else {
                        await widget.notificationService?.cancelDailyReminder();
                      }
                    },
                  ),
                  _NavRow(
                    rowKey: const Key('reminder-time'),
                    icon: Icons.schedule_rounded,
                    tint: _Tint.secondary,
                    title: 'Waktu Pengingat',
                    trailing: _prefs.dailyReminderTime,
                    onTap: _pickTime,
                  ),
                  _SwitchRow(
                    switchKey: const Key('toggle-meditation-reminder'),
                    icon: Icons.self_improvement_rounded,
                    tint: _Tint.primary,
                    title: l10n?.meditationReminderTitle ?? 'Pengingat Meditasi',
                    value: _prefs.meditationReminderEnabled,
                    onChanged: (val) async {
                      await _prefs.setMeditationReminderEnabled(val);
                      if (val) {
                        await widget.notificationService?.requestPermission();
                        await widget.notificationService
                            ?.scheduleMeditationReminder();
                      } else {
                        await widget.notificationService
                            ?.cancelMeditationReminder();
                      }
                    },
                  ),
                  _SwitchRow(
                    switchKey: const Key('toggle-workout-reminder'),
                    icon: Icons.fitness_center_rounded,
                    tint: _Tint.secondary,
                    title: l10n?.workoutReminderTitle ?? 'Pengingat Olahraga',
                    value: _prefs.workoutReminderEnabled,
                    onChanged: (val) async {
                      await _prefs.setWorkoutReminderEnabled(val);
                      if (val) {
                        await widget.notificationService?.requestPermission();
                        await widget.notificationService
                            ?.scheduleWorkoutReminder();
                      } else {
                        await widget.notificationService
                            ?.cancelWorkoutReminder();
                      }
                    },
                  ),
                ],
              ),
              _Section(
                title: l10n?.dataSection ?? 'Data',
                children: [
                  _NavRow(
                    rowKey: const Key('reset-data'),
                    icon: Icons.delete_forever_rounded,
                    tint: _Tint.danger,
                    title: l10n?.resetDataTitle ?? 'Reset Semua Data',
                    danger: true,
                    onTap: _confirmReset,
                  ),
                ],
              ),
              _Section(
                title: l10n?.aboutSection ?? 'Tentang',
                children: [
                  _InfoRow(
                    icon: Icons.info_rounded,
                    tint: _Tint.neutral,
                    title: l10n?.appVersion ?? 'Versi Aplikasi',
                    trailing: '1.0.0',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final current = NotificationService.parseHhmm(_prefs.dailyReminderTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    final hh = picked.hour.toString().padLeft(2, '0');
    final mm = picked.minute.toString().padLeft(2, '0');
    await _prefs.setDailyReminderTime('$hh:$mm');
    if (_prefs.dailyReminderEnabled) {
      await widget.notificationService?.scheduleDailyReminder(picked);
    }
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(l10n?.resetDataConfirmTitle ?? 'Reset Semua Data?'),
          content: Text(
            l10n?.resetDataConfirmContent ??
                'Tindakan ini akan menghapus semua streak, XP, check-in, dan '
                'riwayat sesi secara permanen. Anda akan kembali ke onboarding.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n?.cancel ?? 'Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n?.reset ?? 'Reset'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    final userProvider = context.readOrNull<UserProvider>();
    final checkinProvider = context.readOrNull<CheckinProvider>();
    final meditationProvider = context.readOrNull<MeditationProvider>();
    final workoutProvider = context.readOrNull<WorkoutProvider>();
    final questProvider = context.readOrNull<QuestProvider>();
    final achievementProvider = context.readOrNull<AchievementProvider>();

    final pfpPath = _prefs.userPfpPath;
    if (pfpPath != null) {
      try {
        final file = File(pfpPath);
        if (file.existsSync()) {
          await file.delete();
        }
      } catch (_) {}
    }

    await widget.onResetData();
    await widget.notificationService?.cancelAll();
    await _prefs.resetAll();

    _cachedPfpPath = null;
    _pfpFileExists = false;

    await Future.wait([
      if (userProvider != null) userProvider.loadProfile(),
      if (checkinProvider != null) checkinProvider.loadToday(),
      if (meditationProvider != null) meditationProvider.loadStats(),
      if (workoutProvider != null) workoutProvider.loadStats(),
      if (questProvider != null) questProvider.loadAllQuests(),
      if (achievementProvider != null) achievementProvider.loadAchievements(),
    ]);

    if (!mounted) return;
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.go(Routes.onboarding);
    }
  }
}

class _StatMetric extends StatelessWidget {
  const _StatMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final divider = isDark
        ? AppColors.darkDivider
        : theme.dividerColor.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          Material(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: divider),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) Divider(height: 1, thickness: 1, color: divider),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _Tint { primary, secondary, danger, neutral }

class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.tint});

  final IconData icon;
  final _Tint tint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg;
    final Color fg;
    switch (tint) {
      case _Tint.primary:
        bg = isDark
            ? AppColors.darkPrimaryContainer
            : theme.colorScheme.primaryContainer;
        fg = isDark ? AppColors.darkPrimary : theme.colorScheme.primary;
      case _Tint.secondary:
        bg = isDark
            ? AppColors.darkSecondaryContainer
            : theme.colorScheme.secondaryContainer;
        fg = isDark ? AppColors.darkSecondary : AppColors.secondary;
      case _Tint.danger:
        bg = AppColors.danger.withValues(alpha: isDark ? 0.25 : 0.12);
        fg = AppColors.danger;
      case _Tint.neutral:
        bg = isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05);
        fg = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: fg),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.switchKey,
    required this.icon,
    required this.tint,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final Key switchKey;
  final IconData icon;
  final _Tint tint;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sub = subtitle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _IconChip(icon: icon, tint: tint),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            key: switchKey,
            value: value,
            onChanged: onChanged,
            activeTrackColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.rowKey,
    required this.icon,
    required this.tint,
    required this.title,
    this.trailing,
    this.danger = false,
    required this.onTap,
  });

  final Key rowKey;
  final IconData icon;
  final _Tint tint;
  final String title;
  final String? trailing;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = trailing;
    return InkWell(
      key: rowKey,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _IconChip(icon: icon, tint: tint),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: danger ? AppColors.danger : null,
                ),
              ),
            ),
            if (tr != null)
              Text(
                tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: danger
                  ? AppColors.danger
                  : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.tint,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final _Tint tint;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _IconChip(icon: icon, tint: tint),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            trailing,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
