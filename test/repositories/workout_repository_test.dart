import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/workout_session.dart';
import 'package:rewire/repositories/workout_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'repository_test_db.dart';

void main() {
  late Database db;
  late WorkoutRepository repo;

  WorkoutSession session({
    String date = '2026-09-27',
    String routineId = 'morning_energy',
    int xp = 25,
  }) => WorkoutSession(
    date: date,
    routineId: routineId,
    routineName: 'Morning Energy',
    durationSeconds: 900,
    exercisesCompleted: 6,
    exercisesTotal: 6,
    xpEarned: xp,
  );

  setUp(() async {
    db = await openTestDatabase();
    repo = WorkoutRepository(db);
  });

  tearDown(() async => db.close());

  test('insertSession round-trips through getHistory', () async {
    await repo.insertSession(session(routineId: 'core_crusher'));
    final history = await repo.getHistory();
    expect(history, hasLength(1));
    expect(history.first.routineId, 'core_crusher');
    expect(history.first.exercisesTotal, 6);
  });

  test('completedCount counts all workout sessions', () async {
    await repo.insertSession(session());
    await repo.insertSession(session(date: '2026-09-28'));
    expect(await repo.completedCount(), 2);
  });

  test('completedCount is zero on empty history', () async {
    expect(await repo.completedCount(), 0);
  });
}
