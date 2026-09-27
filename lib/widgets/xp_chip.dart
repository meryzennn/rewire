import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Small badge chip showing rewarded XP (e.g., '+20 XP', '+50 XP').
class XpChip extends StatelessWidget {
  const XpChip({
    super.key,
    required this.amount,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 12,
  });

  final int amount;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBg =
        isDark ? AppColors.darkPrimaryContainer : AppColors.primaryContainer;
    final defaultText =
        isDark ? AppColors.darkPrimary : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '+$amount XP',
        style: TextStyle(
          color: textColor ?? defaultText,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
