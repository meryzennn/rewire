import 'package:flutter/foundation.dart';

import '../repositories/checkin_repository.dart';
import '../services/xp_service.dart';

/// Root provider for daily check-ins: today's status and history (§2.2).
///
/// Thin by design; the check-in screen (§Task 8) adds its state and methods.
class CheckinProvider extends ChangeNotifier {
  CheckinProvider(this._checkins, this._xp);

  final CheckinRepository _checkins;
  final XpService _xp;

  CheckinRepository get checkins => _checkins;
  XpService get xp => _xp;
}
