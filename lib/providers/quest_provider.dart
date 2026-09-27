import 'package:flutter/foundation.dart';

import '../models/quest.dart';
import '../services/quest_service.dart';

/// Root provider for quests: today's daily set and weekly challenges (§2.2).
class QuestProvider extends ChangeNotifier {
  QuestProvider(this._quests);

  final QuestService _quests;

  List<Quest> _dailyQuests = const [];
  bool _isLoading = false;

  QuestService get quests => _quests;
  List<Quest> get dailyQuests => _dailyQuests;
  bool get isLoading => _isLoading;

  int get completedDailyCount =>
      _dailyQuests.where((q) => q.completed == 1).length;

  int get totalDailyCount => _dailyQuests.length;

  /// Loads or refreshes daily quests for [now].
  Future<void> loadDailyQuests({DateTime? now}) async {
    _isLoading = true;
    notifyListeners();

    final target = now ?? DateTime.now();
    _dailyQuests = await _quests.getDailyQuests(target);

    _isLoading = false;
    notifyListeners();
  }
}
