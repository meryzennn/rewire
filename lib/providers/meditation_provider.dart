import 'package:flutter/foundation.dart';

import '../repositories/meditation_repository.dart';
import '../services/xp_service.dart';

/// Root provider for meditation: active session state and history (§2.2).
///
/// Thin by design; the meditation screens (§Task 9) add the timer state and
/// session-completion logic.
class MeditationProvider extends ChangeNotifier {
  MeditationProvider(this._meditation, this._xp);

  final MeditationRepository _meditation;
  final XpService _xp;

  MeditationRepository get meditation => _meditation;
  XpService get xp => _xp;
}
