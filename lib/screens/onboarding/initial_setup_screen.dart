import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../app.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/health_utils.dart';
import '../../core/utils/l10n_utils.dart';
import '../../services/preference_service.dart';

/// Post-onboarding initial profile customization screen (spec §4).
///
/// Collects user identity (avatar, name), language preference, birthday (with
/// dynamic age calculation), height/weight with real-time BMI indicator, and
/// fitness level. Allows immediate bypass via Skip with sensible defaults.
class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key, required this.preferences});

  final PreferenceService preferences;

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  PreferenceService get _prefs => widget.preferences;

  late final TextEditingController _nameController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  DateTime? _birthDate;
  String _fitnessLevel = 'beginner';
  String? _pfpPath;

  static const _allowedExtensions = ['png', 'jpg', 'jpeg', 'webp'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _prefs.userName.isNotEmpty ? _prefs.userName : '');
    _heightController = TextEditingController(
      text: _prefs.userHeight != null ? _prefs.userHeight!.toStringAsFixed(0) : '',
    );
    _weightController = TextEditingController(
      text: _prefs.userWeight != null ? _prefs.userWeight!.toStringAsFixed(0) : '',
    );
    _birthDate = _prefs.userBirthDate;
    _fitnessLevel = _prefs.userFitnessLevel;
    _pfpPath = _prefs.userPfpPath;

    _heightController.addListener(_onMetricsChanged);
    _weightController.addListener(_onMetricsChanged);
  }

  @override
  void dispose() {
    _heightController.removeListener(_onMetricsChanged);
    _weightController.removeListener(_onMetricsChanged);
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onMetricsChanged() {
    setState(() {});
  }

  double? get _currentBmi {
    final h = double.tryParse(_heightController.text.trim());
    final w = double.tryParse(_weightController.text.trim());
    return calculateBmi(h, w);
  }

  int? get _computedAge {
    final bday = _birthDate;
    if (bday == null) return null;
    final now = DateTime.now();
    var age = now.year - bday.year;
    if (now.month < bday.month || (now.month == bday.month && now.day < bday.day)) {
      age--;
    }
    return age;
  }

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
              content: Text('PNG, JPG, JPEG, WEBP formats allowed.'),
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
      if (mounted) {
        setState(() => _pfpPath = targetPath);
      }
    } catch (_) {
      // Graceful fallback for environments without gallery picker
    }
  }

  Future<void> _selectBirthday() async {
    final initial = _birthDate ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _skip() async {
    if (_prefs.userName.isEmpty) {
      await _prefs.setUserName('Anon');
    }
    await _prefs.setOnboardingCompleted(true);
    if (!mounted) return;
    context.go(Routes.home);
  }

  Future<void> _saveAndContinue() async {
    final rawName = _nameController.text.trim();
    await _prefs.setUserName(rawName.isNotEmpty ? rawName : 'Anon');

    final h = double.tryParse(_heightController.text.trim());
    if (h != null && h > 0) {
      await _prefs.setUserHeight(h);
    }

    final w = double.tryParse(_weightController.text.trim());
    if (w != null && w > 0) {
      await _prefs.setUserWeight(w);
    }

    if (_birthDate != null) {
      await _prefs.setUserBirthDate(_birthDate);
    }

    await _prefs.setUserFitnessLevel(_fitnessLevel);
    await _prefs.setOnboardingCompleted(true);

    if (!mounted) return;
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final primary = isDark ? AppColors.darkPrimary : AppColors.primary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final cardBorder = isDark ? AppColors.darkDivider : AppColors.divider;

    final bmi = _currentBmi;
    final bmiCat = getBmiCategory(bmi);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.setupTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            key: const Key('setup-skip-button'),
            onPressed: _skip,
            child: Text(
              l10n.skip,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Language Selector Card
                  _buildSectionCard(
                    title: l10n.languageChoice,
                    surfaceColor: surfaceColor,
                    borderColor: cardBorder,
                    child: _buildLanguageChips(primary, cardBorder),
                  ),
                  const SizedBox(height: 16),

                  // 2. Identity Card (PFP + Name)
                  _buildSectionCard(
                    title: 'Profile',
                    surfaceColor: surfaceColor,
                    borderColor: cardBorder,
                    child: Column(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _pickProfilePicture,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: primary.withValues(alpha: 0.2),
                                  backgroundImage: _pfpPath != null
                                      ? FileImage(File(_pfpPath!))
                                      : null,
                                  child: _pfpPath == null
                                      ? Icon(Icons.person, size: 44, color: primary)
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          key: const Key('setup-name-input'),
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Anon',
                            prefixIcon: const Icon(Icons.badge_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Birthday Card
                  _buildSectionCard(
                    title: l10n.birthdayLabel,
                    surfaceColor: surfaceColor,
                    borderColor: cardBorder,
                    child: InkWell(
                      key: const Key('setup-birthday-picker'),
                      onTap: _selectBirthday,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: cardBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.cake_outlined, color: primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _birthDate != null
                                    ? '${_birthDate!.day} ${_months[_birthDate!.month - 1]} ${_birthDate!.year} ($_computedAge ${l10n.yearsOldLabel})'
                                    : l10n.birthdayLabel,
                                style: TextStyle(
                                  color: _birthDate != null ? textPrimary : textSecondary,
                                  fontSize: 15,
                                  fontWeight: _birthDate != null ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                            const Icon(Icons.calendar_today_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Body Metrics Card (Height, Weight, Live BMI)
                  _buildSectionCard(
                    title: 'Body Metrics',
                    surfaceColor: surfaceColor,
                    borderColor: cardBorder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: const Key('setup-height-input'),
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Height',
                                  suffixText: 'cm',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                key: const Key('setup-weight-input'),
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Weight',
                                  suffixText: 'kg',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildBmiIndicator(bmi, bmiCat, l10n, isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Fitness Level Card
                  _buildSectionCard(
                    title: l10n.fitnessLevelLabel,
                    surfaceColor: surfaceColor,
                    borderColor: cardBorder,
                    child: Column(
                      children: [
                        _buildFitnessTile(
                          levelKey: 'beginner',
                          widgetKey: 'setup-fitness-beginner',
                          title: l10n.beginner,
                          desc: l10n.beginnerDesc,
                          primary: primary,
                          border: cardBorder,
                        ),
                        const SizedBox(height: 10),
                        _buildFitnessTile(
                          levelKey: 'intermediate',
                          widgetKey: 'setup-fitness-intermediate',
                          title: l10n.intermediate,
                          desc: l10n.intermediateDesc,
                          primary: primary,
                          border: cardBorder,
                        ),
                        const SizedBox(height: 10),
                        _buildFitnessTile(
                          levelKey: 'expert',
                          widgetKey: 'setup-fitness-expert',
                          title: l10n.expert,
                          desc: l10n.expertDesc,
                          primary: primary,
                          border: cardBorder,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

            // 6. Bottom Sticky Action
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(top: BorderSide(color: cardBorder)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  key: const Key('setup-continue-button'),
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    '${l10n.continueToApp} ✓',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Color surfaceColor,
    required Color borderColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildLanguageChips(Color primary, Color border) {
    const languages = [
      ('en', 'English'),
      ('id', 'Indonesia'),
      ('es', 'Español'),
      ('ja', '日本語'),
    ];

    final current = _prefs.language;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: languages.map((lang) {
        final isSelected = current == lang.$1;
        return ChoiceChip(
          key: Key('lang-chip-${lang.$1}'),
          label: Text(lang.$2),
          selected: isSelected,
          onSelected: (_) async {
            await _prefs.setLanguage(lang.$1);
          },
          selectedColor: primary.withValues(alpha: 0.25),
        );
      }).toList(),
    );
  }

  Widget _buildBmiIndicator(
    double? bmi,
    BmiCategory category,
    AppLocalizations l10n,
    bool isDark,
  ) {
    if (bmi == null) {
      return Container(
        key: const Key('setup-bmi-indicator'),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${l10n.bmiLabel}: --',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      );
    }

    final catLabel = switch (category) {
      BmiCategory.underweight => l10n.bmiUnderweight,
      BmiCategory.normal => l10n.bmiNormal,
      BmiCategory.overweight => l10n.bmiOverweight,
      BmiCategory.obese => l10n.bmiObese,
    };

    final badgeColor = switch (category) {
      BmiCategory.normal => AppColors.success,
      BmiCategory.underweight => AppColors.secondary,
      BmiCategory.overweight => AppColors.warning,
      BmiCategory.obese => AppColors.danger,
    };

    return Container(
      key: const Key('setup-bmi-indicator'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            category == BmiCategory.obese ? Icons.warning_amber_rounded : Icons.health_and_safety,
            size: 18,
            color: badgeColor,
          ),
          const SizedBox(width: 8),
          Text(
            '${l10n.bmiLabel}: ${bmi.toStringAsFixed(1)} ($catLabel)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessTile({
    required String levelKey,
    required String widgetKey,
    required String title,
    required String desc,
    required Color primary,
    required Color border,
  }) {
    final isSelected = _fitnessLevel == levelKey;

    return InkWell(
      key: Key(widgetKey),
      onTap: () => setState(() => _fitnessLevel = levelKey),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : border,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? primary.withValues(alpha: 0.08) : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? primary : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primary : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
