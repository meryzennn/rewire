import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/screens/meditation/active_meditation_screen.dart';
import 'package:rewire/services/audio_service.dart';

Widget buildActiveScreen({
  required int durationMinutes,
  String trackId = 'rain',
  String? breathingId,
  required AudioService audioService,
}) {
  return MaterialApp(
    home: ActiveMeditationScreen(
      durationMinutes: durationMinutes,
      trackId: trackId,
      breathingId: breathingId,
      audioService: audioService,
    ),
  );
}

void main() {
  testWidgets('renders active meditation screen with timer and track info', (
    tester,
  ) async {
    final fakeAudio = FakeAudioService();

    await tester.pumpWidget(
      buildActiveScreen(
        durationMinutes: 10,
        trackId: 'rain',
        breathingId: 'box',
        audioService: fakeAudio,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Audio should start playing
    expect(fakeAudio.isPlaying, isTrue);
    expect(fakeAudio.currentTrack, 'rain');

    // Timer display
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('/ 10:00'), findsOneWidget);

    // Track label
    expect(find.text('Hujan'), findsOneWidget);

    // Breathing phase
    expect(find.text('Tarik napas...'), findsOneWidget);

    // Controls
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
  });

  testWidgets('timer counts down with each elapsed second', (tester) async {
    final fakeAudio = FakeAudioService();

    await tester.pumpWidget(
      buildActiveScreen(
        durationMinutes: 5,
        trackId: 'forest',
        audioService: fakeAudio,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('05:00'), findsOneWidget);

    // Advance 3 seconds
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('04:57'), findsOneWidget);
  });

  testWidgets('pause button stops timer countdown and audio', (tester) async {
    final fakeAudio = FakeAudioService();

    await tester.pumpWidget(
      buildActiveScreen(durationMinutes: 5, audioService: fakeAudio),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(fakeAudio.isPlaying, isTrue);

    // Tap pause
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump(const Duration(milliseconds: 100));

    expect(fakeAudio.isPlaying, isFalse);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

    // Advance time while paused
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('05:00'), findsOneWidget);

    // Tap resume
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump(const Duration(milliseconds: 100));

    expect(fakeAudio.isPlaying, isTrue);
  });

  testWidgets('stop button shows confirmation dialog', (tester) async {
    final fakeAudio = FakeAudioService();

    await tester.pumpWidget(
      buildActiveScreen(durationMinutes: 10, audioService: fakeAudio),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Tap stop
    await tester.tap(find.byIcon(Icons.stop_rounded));
    await tester.pump(const Duration(milliseconds: 200));

    // Confirmation dialog
    expect(find.text('Akhiri Sesi Meditasi?'), findsOneWidget);
    expect(find.text('Lanjut Meditasi'), findsOneWidget);
    expect(find.text('Akhiri Sesi'), findsOneWidget);

    // Tap continue
    await tester.tap(find.text('Lanjut Meditasi'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Akhiri Sesi Meditasi?'), findsNothing);
  });
}
