import 'package:flutter/foundation.dart';

import '../models/quest.dart';
import '../services/quest_service.dart';

/// Root provider for quests: today's daily set and weekly challenges (§2.2).
class QuestProvider extends ChangeNotifier {
  QuestProvider(this._quests);

  final QuestService _quests;

  List<Quest> _dailyQuests = const [];
  List<Quest> _weeklyQuests = const [];
  bool _isLoading = false;

  QuestService get quests => _quests;
  List<Quest> get dailyQuests => _dailyQuests;
  List<Quest> get weeklyQuests => _weeklyQuests;
  bool get isLoading => _isLoading;

  int get completedDailyCount =>
      _dailyQuests.where((q) => q.completed == 1).length;

  int get totalDailyCount => _dailyQuests.length;

  int get completedWeeklyCount =>
      _weeklyQuests.where((q) => q.completed == 1).length;

  int get totalWeeklyCount => _weeklyQuests.length;

  /// Loads or refreshes daily quests for [now].
  Future<void> loadDailyQuests({DateTime? now}) async {
    _isLoading = true;
    notifyListeners();

    final target = now ?? DateTime.now();
    _dailyQuests = await _quests.getDailyQuests(target);

    _isLoading = false;
    notifyListeners();
  }

  /// Loads weekly challenges for [now].
  Future<void> loadWeeklyQuests({DateTime? now}) async {
    final target = now ?? DateTime.now();
    _weeklyQuests = await _quests.getWeeklyQuests(target);
    notifyListeners();
  }

  /// Loads both daily quests and weekly challenges.
  Future<void> loadAllQuests({DateTime? now}) async {
    _isLoading = true;
    notifyListeners();

    final target = now ?? DateTime.now();
    _dailyQuests = await _quests.getDailyQuests(target);
    _weeklyQuests = await _quests.getWeeklyQuests(target);

    _isLoading = false;
    notifyListeners();
  }
}
