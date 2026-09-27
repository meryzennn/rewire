import 'package:flutter/foundation.dart';

import '../services/quest_service.dart';

/// Root provider for quests: today's daily set and weekly challenges (§2.2).
///
/// Thin by design; the Home and Progress screens (§Task 7, 12) add the loaded
/// quest lists and refresh/record calls over [QuestService].
class QuestProvider extends ChangeNotifier {
  QuestProvider(this._quests);

  final QuestService _quests;

  QuestService get quests => _quests;
}
