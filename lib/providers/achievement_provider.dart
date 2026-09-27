import 'package:flutter/foundation.dart';

import '../services/achievement_service.dart';

/// Root provider for achievements: badge unlock status (§2.2).
///
/// Thin by design; the Progress screen (§Task 12) adds the loaded badge list
/// and the unlock-evaluation calls over [AchievementService].
class AchievementProvider extends ChangeNotifier {
  AchievementProvider(this._achievements);

  final AchievementService _achievements;

  AchievementService get achievements => _achievements;
}
