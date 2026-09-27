import 'package:flutter/foundation.dart';

import '../repositories/workout_repository.dart';
import '../services/xp_service.dart';

/// Root provider for workouts: active routine state and history (§2.2).
///
/// Thin by design; the workout screens (§Task 10, 11) add the active-session
/// timer and current-exercise state.
class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider(this._workouts, this._xp);

  final WorkoutRepository _workouts;
  final XpService _xp;

  WorkoutRepository get workouts => _workouts;
  XpService get xp => _xp;
}
