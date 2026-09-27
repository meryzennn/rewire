import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/data/exercises.dart';
import 'package:rewire/data/meditation_definitions.dart';

void main() {
  group('Asset verification tests (Task 14)', () {
    test('all 5 brain evolution stage assets exist and are valid PNGs', () {
      const stages = [
        'dormant',
        'awakening',
        'growing',
        'thriving',
        'transcendent',
      ];
      for (final stage in stages) {
        final file = File('assets/images/brain/$stage.png');
        expect(file.existsSync(), isTrue, reason: '$stage.png must exist');
        expect(
          file.lengthSync(),
          greaterThan(1000),
          reason: '$stage.png must have data',
        );
      }
    });

    test('onboarding welcome brain asset exists and is valid', () {
      final file = File('assets/images/onboarding/welcome_brain.png');
      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), greaterThan(1000));
    });

    test('all 15 exercise illustrations declared in kAllExercises exist on disk', () {
      expect(kAllExercises, hasLength(15));
      for (final exercise in kAllExercises) {
        final file = File(exercise.imageAssetPath);
        expect(
          file.existsSync(),
          isTrue,
          reason:
              'Exercise ${exercise.id} path ${exercise.imageAssetPath} must exist',
        );
        expect(
          file.lengthSync(),
          greaterThan(500),
          reason: 'Exercise ${exercise.id} illustration must not be empty',
        );
      }
    });

    test(
      'all 6 ambient audio tracks declared in kAmbientTracks exist on disk',
      () {
        expect(kAmbientTracks, hasLength(6));
        for (final track in kAmbientTracks) {
          final file = File(track.assetPath);
          expect(
            file.existsSync(),
            isTrue,
            reason: 'Audio track ${track.id} at ${track.assetPath} must exist',
          );
          expect(
            file.lengthSync(),
            greaterThan(1000),
            reason: 'Audio track ${track.id} must not be empty',
          );
        }
      },
    );

    test(
      'all 4 content definitions in assets/data exist and are valid JSON',
      () {
        const jsonFiles = [
          'assets/data/exercises.json',
          'assets/data/routines.json',
          'assets/data/quests.json',
          'assets/data/achievements.json',
        ];
        for (final path in jsonFiles) {
          final file = File(path);
          expect(file.existsSync(), isTrue, reason: '$path must exist');
          final content = file.readAsStringSync();
          expect(content, isNotEmpty);
          expect(
            () => jsonDecode(content),
            returnsNormally,
            reason: '$path must be valid JSON',
          );
        }
      },
    );
  });
}
