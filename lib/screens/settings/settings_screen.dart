import 'package:flutter/material.dart';

import '../profile/profile_screen.dart';
import '../../services/notification_service.dart';
import '../../services/preference_service.dart';

export '../profile/profile_screen.dart';

/// Legacy alias for [ProfileScreen] to preserve backward compatibility.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.preferences,
    required this.onResetData,
    this.notificationService,
  });

  final PreferenceService preferences;
  final Future<void> Function() onResetData;
  final NotificationService? notificationService;

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      preferences: preferences,
      onResetData: onResetData,
      notificationService: notificationService,
    );
  }
}
