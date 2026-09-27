import 'package:flutter/foundation.dart';

import '../models/achievement.dart';
import '../services/achievement_service.dart';

/// Root provider for achievements: badge unlock status (§2.2, Task 12).
class AchievementProvider extends ChangeNotifier {
  AchievementProvider(this._achievements);

  final AchievementService _achievements;

  AchievementService get achievements => _achievements;

  List<Achievement> _items = const [];
  bool _isLoading = false;

  List<Achievement> get items => _items;
  bool get isLoading => _isLoading;
  int get unlockedCount => _items.where((a) => a.unlocked == 1).length;
  int get totalCount => _items.length;

  /// Loads achievements, checks and unlocks any newly earned ones, and updates state.
  Future<void> loadAchievements({DateTime? now}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _achievements.checkAndUnlock(now: now);
      _items = await _achievements.getAllAchievements();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
