import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/checkin_provider.dart';

/// Available predefined trigger chips (spec §3.4 & Stitch Daily Check-in screen).
const List<String> kAvailableTriggers = [
  'Stres',
  'Bosan',
  'Kelelahan',
  'Sosial Media',
  'Kesepian',
  'Lainnya',
];

/// Daily Check-in Screen matching Stitch MCP screen 65f4ab2ac4794e7e95e8294e4c5ed56f.
class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key, this.provider});

  final CheckinProvider? provider;

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  String _selectedStatus = 'clean';
  int? _selectedMood;
  final Set<String> _selectedTriggers = {};
  late final TextEditingController _notesController;
  bool _isSaving = false;

  CheckinProvider _getProvider(BuildContext context) =>
      widget.provider ?? context.read<CheckinProvider>();

  final List<Map<String, dynamic>> _moods = const [
    {'value': 1, 'emoji': '😫', 'label': 'Kacau'},
    {'value': 2, 'emoji': '😟', 'label': 'Cemas'},
    {'value': 3, 'emoji': '😐', 'label': 'Biasa'},
    {'value': 4, 'emoji': '🙂', 'label': 'Tenang'},
    {'value': 5, 'emoji': '😄', 'label': 'Penuh Daya'},
  ];

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = _getProvider(context);
      final today = provider.todayCheckin;
      if (today != null && mounted) {
        setState(() {
          _selectedStatus = today.status;
          _selectedMood = today.mood;
          _notesController.text = today.notes ?? '';
          _selectedTriggers.addAll(provider.todayTriggers);
        });
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showHelpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Check-in Harian',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Catat evaluasi dirimu setiap hari untuk melacak kebiasaan dan perkembangan pemulihanmu.\n\n'
          '• Check-in bersih menambah streak dan memberikan +20 XP.\n'
          '• Jika terjadi relapse, jangan berkecil hati—total XP dan levelmu tetap aman, dan kamu berhak bangkit kembali.',
          style: TextStyle(height: 1.5, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Mengerti',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRelapseEncouragementDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.spa_outlined,
                color: AppColors.danger,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak apa-apa.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Setiap proses butuh waktu. Yang terpenting adalah keberanianmu untuk jujur dan bangkit kembali.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Streak kamu akan direset, tapi total XP dan level tetap tersimpan utuh.',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Mulai Lagi 💪',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitCheckin() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final provider = _getProvider(context);
    final isRelapse = _selectedStatus == 'relapse';
    final wasAlreadyCheckedIn = provider.hasCheckedInToday;

    try {
      await provider.submitCheckin(
        status: _selectedStatus,
        mood: _selectedMood,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        triggers: _selectedTriggers.toList(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan check-in: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return;
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }

    if (!mounted) return;

    if (isRelapse) {
      await _showRelapseEncouragementDialog(context);
      if (mounted) {
        Navigator.of(context).maybePop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                wasAlreadyCheckedIn
                    ? 'Check-in berhasil diperbarui!'
                    : 'Check-in berhasil disimpan!',
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final checkinProvider = widget.provider ?? context.watch<CheckinProvider>();

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final surfaceVariantColor = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.surfaceVariant;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final primaryContainer = isDark
        ? AppColors.darkPrimaryContainer
        : AppColors.primaryContainer;

    final now = DateTime.now();
    final todayFormatted = formatIndonesianDate(now);

    final currentStreak = checkinProvider.currentStreak;
    final hasCheckedIn = checkinProvider.todayCheckin != null;
    final displayStreak =
        hasCheckedIn && checkinProvider.todayCheckin?.status == 'clean'
        ? currentStreak
        : (currentStreak > 0 ? currentStreak + 1 : 1);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Check-in Harian',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: textSecondary),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. DATE & STREAK HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          todayFormatted,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 16,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                currentStreak > 0
                                    ? 'Streak Berjalan'
                                    : 'Mulai Baru',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Hari ke-$displayStreak',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentStreak > 0
                              ? 'bersih tanpa distraksi'
                              : 'langkah pemulihan',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 1b. ALREADY CHECKED IN BANNER
                    if (hasCheckedIn) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? primaryContainer.withValues(alpha: 0.25)
                              : primaryContainer.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: primaryColor,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kamu sudah check-in hari ini',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Data check-in hari ini sudah tersimpan. Kamu bisa memperbarui data jika kondisi berubah di malam hari (seperti mood atau jika terjadi relapse).',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: textPrimary.withValues(alpha: 0.85),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 2. STATUS QUESTION & SELECTION CARDS
                    Text(
                      'Bagaimana hari ini?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Card 1: Hari yang Bersih
                    _StatusCard(
                      title: 'Hari yang Bersih',
                      subtitle: 'Berhasil menjaga komitmen & melewati godaan dengan tenang.',
                      isSelected: _selectedStatus == 'clean',
                      icon: Icons.check_circle,
                      iconColor: primaryColor,
                      selectedBorderColor: primaryColor,
                      selectedBgColor: primaryContainer.withValues(alpha: 0.35),
                      surfaceColor: surfaceColor,
                      dividerColor: dividerColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTap: () => setState(() {
                        _selectedStatus = 'clean';
                        _selectedTriggers.clear();
                      }),
                    ),
                    const SizedBox(height: 12),
                    // Card 2: Relapse Hari ini
                    _StatusCard(
                      title: 'Relapse Hari ini',
                      subtitle: 'Setiap proses butuh waktu, kamu tetap berharga dan berhak bangkit lagi.',
                      isSelected: _selectedStatus == 'relapse',
                      icon: Icons.autorenew,
                      iconColor: AppColors.danger,
                      selectedBorderColor: AppColors.danger,
                      selectedBgColor: AppColors.danger.withValues(alpha: 0.12),
                      surfaceColor: surfaceColor,
                      dividerColor: dividerColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTap: () => setState(() => _selectedStatus = 'relapse'),
                    ),
                    const SizedBox(height: 24),

                    // 3. MOOD SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mood kamu hari ini?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          'Pilih salah satu',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: dividerColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _moods.map((m) {
                          final int value = m['value'] as int;
                          final String emoji = m['emoji'] as String;
                          final String label = m['label'] as String;
                          final isSelected = _selectedMood == value;

                          return InkWell(
                            onTap: () => setState(() {
                              _selectedMood = isSelected ? null : value;
                            }),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryContainer
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    emoji,
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: isSelected ? null : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    label,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: isSelected
                                          ? primaryColor
                                          : textSecondary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. TRIGGER SECTION (Hanya tampil saat status Relapse)
                    if (_selectedStatus == 'relapse') ...[
                      Row(
                        children: [
                          Text(
                            'Pemicu (trigger) relapse?',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: surfaceVariantColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Opsional',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: kAvailableTriggers.map((trigger) {
                          final isSelected = _selectedTriggers.contains(trigger);
                          return FilterChip(
                            selected: isSelected,
                            showCheckmark: true,
                            label: Text(trigger),
                            labelStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? primaryColor : textSecondary,
                            ),
                            backgroundColor: surfaceColor,
                            selectedColor: primaryContainer,
                            checkmarkColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? primaryColor.withValues(alpha: 0.5)
                                    : dividerColor,
                              ),
                            ),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedTriggers.add(trigger);
                                } else {
                                  _selectedTriggers.remove(trigger);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      _selectedStatus == 'relapse'
                          ? 'Catatan Evaluasi (Opsional)'
                          : 'Catatan & Rasa Syukur Hari Ini (Opsional)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      maxLength: 250,
                      style: TextStyle(color: textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: _selectedStatus == 'relapse'
                            ? 'Tulis apa yang memicu relapse atau hal yang bisa dipelajari...'
                            : 'Tulis hal positif atau rasa syukur yang membantumu tetap bersih...',
                        hintStyle: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: surfaceColor,
                        contentPadding: const EdgeInsets.all(14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: dividerColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // 5. BOTTOM ACTION BUTTON & SUPPORTIVE MICRO-COPY
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _isSaving ? null : _submitCheckin,
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              hasCheckedIn
                                  ? Icons.sync_rounded
                                  : Icons.task_alt,
                              size: 22,
                            ),
                      label: Text(
                        _isSaving
                            ? 'Menyimpan...'
                            : (hasCheckedIn
                                ? 'Perbarui Check-in'
                                : 'Simpan Check-in'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.spa, size: 15, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Satu langkah kecil sadar untuk membentuk jalur otak yang baru.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textSecondary,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.icon,
    required this.iconColor,
    required this.selectedBorderColor,
    required this.selectedBgColor,
    required this.surfaceColor,
    required this.dividerColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final IconData icon;
  final Color iconColor;
  final Color selectedBorderColor;
  final Color selectedBgColor;
  final Color surfaceColor;
  final Color dividerColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? selectedBgColor : surfaceColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? selectedBorderColor : dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? selectedBorderColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? selectedBorderColor : dividerColor,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
