import 'package:flutter/foundation.dart';

import '../repositories/user_repository.dart';
import '../services/xp_service.dart';

/// Root provider for user progression: level, XP, streak, brain stage (§2.2).
///
/// Thin by design. It owns the user repository and XP service and exposes them
/// to the screen tasks that follow (Home §Task 7, Progress §Task 12), which add
/// the loaded state and mutation methods they need. Kept at the app root so
/// Task 13 can preserve it.
class UserProvider extends ChangeNotifier {
  UserProvider(this._users, this._xp);

  final UserRepository _users;
  final XpService _xp;

  UserRepository get users => _users;
  XpService get xp => _xp;
}
