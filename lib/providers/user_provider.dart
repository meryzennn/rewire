import 'package:flutter/foundation.dart';

import '../core/utils/xp_utils.dart';
import '../models/user_profile.dart';
import '../repositories/user_repository.dart';
import '../services/xp_service.dart';

/// Root provider for user progression: level, XP, streak, brain stage (§2.2).
class UserProvider extends ChangeNotifier {
  UserProvider(this._users, this._xp);

  final UserRepository _users;
  final XpService _xp;

  UserProfile? _profile;
  bool _isLoading = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  UserRepository get users => _users;
  XpService get xp => _xp;

  int get level => _profile?.level ?? 1;
  int get totalXp => _profile?.totalXp ?? 0;
  int get currentStreak => _profile?.currentStreak ?? 0;
  int get longestStreak => _profile?.longestStreak ?? 0;
  String get brainStage => _profile?.brainStage ?? 'dormant';

  /// Ratio (0.0 to 1.0) towards the next level.
  double get levelProgress => levelProgressFraction(totalXp);

  /// Current XP accumulated within the current level.
  int get xpInLevel => xpProgressInLevel(totalXp);

  /// XP needed to complete the current level.
  int get xpSpan => xpSpanForLevel(level);

  /// Loads the persisted user profile, creating it on first run.
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    _profile = await _users.getOrCreateProfile();

    _isLoading = false;
    notifyListeners();
  }

  /// Awards [amount] XP and notifies listeners of level/progress changes.
  Future<XpAward> awardXp(int amount) async {
    final award = await _xp.award(amount);
    _profile = await _users.getProfile();
    notifyListeners();
    return award;
  }
}
