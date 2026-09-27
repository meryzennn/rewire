import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/models/meditation_session.dart';
import 'package:rewire/repositories/meditation_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'repository_test_db.dart';

void main() {
  late Database db;
  late MeditationRepository repo;

  MeditationSession session({
    String date = '2026-09-27',
    int seconds = 300,
    String? audio = 'rain',
    int completed = 1,
    int xp = 10,
  }) => MeditationSession(
    date: date,
    durationSeconds: seconds,
    audioType: audio,
    xpEarned: xp,
    completed: completed,
  );

  setUp(() async {
    db = await openTestDatabase();
    repo = MeditationRepository(db);
  });

  tearDown(() async => db.close());

  test('insertSession round-trips through getHistory', () async {
    await repo.insertSession(session(seconds: 600, audio: 'ocean'));
    final history = await repo.getHistory();
    expect(history, hasLength(1));
    expect(history.first.durationSeconds, 600);
    expect(history.first.audioType, 'ocean');
  });

  test('totals count only completed sessions', () async {
    await repo.insertSession(session(seconds: 300, completed: 1));
    await repo.insertSession(session(date: '2026-09-28', seconds: 900));
    await repo.insertSession(
      session(date: '2026-09-28', seconds: 1200, completed: 0),
    );

    expect(await repo.totalCompletedSeconds(), 1200);
    expect(await repo.completedCount(), 2);
  });

  test('totals are zero on empty history', () async {
    expect(await repo.totalCompletedSeconds(), 0);
    expect(await repo.completedCount(), 0);
  });
}
