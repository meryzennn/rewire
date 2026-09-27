import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../services/notification_service.dart';
import '../../services/preference_service.dart';

/// Settings tab (`/settings`), restyled to the Stitch "Settings" screen
/// (projects/4347317367430667480/screens/35532a33b536478aa961e4f08bd4ee98):
/// grouped cards with an uppercase section label, a tinted leading icon chip
/// per row, and trailing switches / values.
///
/// Persists ONLY spec §2.5 keys through [preferences]; reminder rows persist
/// and schedule alarms via [notificationService] (Task 13). "Reset Semua Data"
/// wipes the local DB (via [onResetData]), cancels scheduled alarms, and wipes
/// prefs behind a confirmation dialog.
///
/// antislop Design Read: preferences screen for a recovery-app user, in the
/// Rewire calm sage/cream language (DESIGN.md), dial ENERGY 1 / RHYTHM 1 /
/// MOTION 1. Uniform grouped rows are the deliberate, honest pattern for
/// settings; accent = sage primary on active toggles, danger reserved for the
/// one destructive row.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.preferences,
    required this.onResetData,
    this.notificationService,
  });

  final PreferenceService preferences;

  /// Wipes local database rows. Kept as a callback so the screen stays testable
  /// without a real database.
  final Future<void> Function() onResetData;

  /// Service managing local notification reminders (spec §8).
  final NotificationService? notificationService;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PreferenceService get _prefs => widget.preferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('screen-settings'),
      appBar: AppBar(title: const Text('Pengaturan')),
      body: AnimatedBuilder(
        animation: _prefs,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Section(
                title: 'Tampilan',
                children: [
                  _SwitchRow(
                    switchKey: const Key('toggle-dark-mode'),
                    icon: Icons.dark_mode_rounded,
                    tint: _Tint.secondary,
                    title: 'Mode Gelap',
                    subtitle: 'Ubah ke tema gelap',
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: _prefs.setDarkMode,
                  ),
                  _InfoRow(
                    icon: Icons.language_rounded,
                    tint: _Tint.primary,
                    title: 'Bahasa',
                    // Indonesian-only in v1; display-only, no locale switcher yet.
                    trailing: 'Indonesia',
                  ),
                ],
              ),
              // SECTIONS_ANCHOR
              _Section(
                title: 'Notifikasi',
                children: [
                  _SwitchRow(
                    switchKey: const Key('toggle-daily-reminder'),
                    icon: Icons.notifications_rounded,
                    tint: _Tint.primary,
                    title: 'Pengingat Harian',
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
                    title: 'Pengingat Meditasi',
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
                    title: 'Pengingat Olahraga',
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
                title: 'Data',
                children: [
                  _NavRow(
                    rowKey: const Key('reset-data'),
                    icon: Icons.delete_forever_rounded,
                    tint: _Tint.danger,
                    title: 'Reset Semua Data',
                    danger: true,
                    onTap: _confirmReset,
                  ),
                ],
              ),
              _Section(
                title: 'Tentang',
                children: const [
                  _InfoRow(
                    icon: Icons.info_rounded,
                    tint: _Tint.neutral,
                    title: 'Versi Aplikasi',
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

  /// Destructive and irreversible: gate the wipe behind an explicit confirm.
  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Semua Data?'),
        content: const Text(
          'Semua progres, streak, dan riwayatmu akan dihapus permanen. '
          'Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    // Wipe DB rows first, then the app's §2.5 prefs, cancel alarms, then hand
    // back to the gate: with onboarding_completed cleared, `.go('/')` redirects
    // to onboarding.
    await widget.onResetData();
    await _prefs.resetAll();
    await widget.notificationService?.cancelAll();
    if (!mounted) return;
    context.go('/');
  }
}

/// Which token family tints a row's leading icon chip.
enum _Tint { primary, secondary, danger, neutral }

class _Palette {
  const _Palette(this.context);
  final BuildContext context;

  ThemeData get _theme => Theme.of(context);
  bool get isDark => _theme.brightness == Brightness.dark;
  Color get surface => _theme.colorScheme.surface;
  Color get divider => _theme.dividerColor;
  Color get ink => _theme.colorScheme.onSurface;
  Color get muted =>
      _theme.textTheme.bodySmall?.color ??
      (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);
  Color get danger => _theme.colorScheme.error;

  /// (chip background, icon color) for a tint. Chip bg is a soft wash; the icon
  /// stays in a readable ink so the glyph is legible in both themes.
  (Color, Color) chip(_Tint tint) {
    switch (tint) {
      case _Tint.primary:
        final base = _theme.colorScheme.primary;
        return (base.withValues(alpha: 0.18), ink);
      case _Tint.secondary:
        final base = _theme.colorScheme.secondary;
        return (base.withValues(alpha: 0.20), ink);
      case _Tint.danger:
        return (danger.withValues(alpha: 0.16), danger);
      case _Tint.neutral:
        return (
          _theme.inputDecorationTheme.fillColor ??
              (isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant),
          ink,
        );
    }
  }
}

/// A titled group: uppercase label above a rounded surface card whose rows are
/// separated by hairline dividers (Stitch section pattern).
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = _Palette(context);
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(Divider(height: 1, thickness: 1, color: palette.divider));
      }
      rows.add(children[i]);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: palette.muted, letterSpacing: 1.1),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.divider),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(children: rows),
          ),
        ],
      ),
    );
  }
}

/// Leading tinted icon chip shared by every row.
class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.tint});

  final IconData icon;
  final _Tint tint;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _Palette(context).chip(tint);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: fg),
    );
  }
}

/// Row with a title (and optional subtitle) plus a trailing [Switch].
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.switchKey,
    required this.icon,
    required this.tint,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
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
    final palette = _Palette(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
      child: Row(
        children: [
          _Chip(icon: icon, tint: tint),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: palette.ink),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: palette.muted),
                  ),
              ],
            ),
          ),
          Switch(key: switchKey, value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// Tappable row with an optional trailing value and a chevron. [danger] colors
/// the title and chevron with the error token for the destructive reset.
class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.rowKey,
    required this.icon,
    required this.tint,
    required this.title,
    required this.onTap,
    this.trailing,
    this.danger = false,
  });

  final Key rowKey;
  final IconData icon;
  final _Tint tint;
  final String title;
  final VoidCallback onTap;
  final String? trailing;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final palette = _Palette(context);
    final titleColor = danger ? palette.danger : palette.ink;
    return InkWell(
      key: rowKey,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
        child: Row(
          children: [
            _Chip(icon: icon, tint: tint),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: titleColor),
              ),
            ),
            if (trailing != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: palette.isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trailing!,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: palette.ink),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: danger ? palette.danger : palette.muted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Static, non-interactive row with a trailing value (no dead chevron).
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
    final palette = _Palette(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      child: Row(
        children: [
          _Chip(icon: icon, tint: tint),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: palette.ink),
            ),
          ),
          Text(
            trailing,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: palette.muted),
          ),
        ],
      ),
    );
  }
}
