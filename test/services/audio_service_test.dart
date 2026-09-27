import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/services/audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FakeAudioService', () {
    late FakeAudioService audio;

    setUp(() {
      audio = FakeAudioService();
    });

    test('starts playback and records track', () async {
      expect(audio.isPlaying, isFalse);
      expect(audio.currentTrack, isNull);

      await audio.play('rain');

      expect(audio.isPlaying, isTrue);
      expect(audio.currentTrack, 'rain');
      expect(audio.callLog, contains('play:rain'));
    });

    test('pause and resume toggle isPlaying correctly', () async {
      await audio.play('forest');
      expect(audio.isPlaying, isTrue);

      await audio.pause();
      expect(audio.isPlaying, isFalse);
      expect(audio.currentTrack, 'forest');

      await audio.resume();
      expect(audio.isPlaying, isTrue);
    });

    test('stop clears track and resets isPlaying', () async {
      await audio.play('campfire');
      await audio.stop();

      expect(audio.isPlaying, isFalse);
      expect(audio.currentTrack, isNull);
    });

    test('setVolume clamps between 0.0 and 1.0', () async {
      await audio.setVolume(0.5);
      expect(audio.volume, 0.5);

      await audio.setVolume(1.5);
      expect(audio.volume, 1.0);

      await audio.setVolume(-0.2);
      expect(audio.volume, 0.0);
    });
  });

  group('DefaultAudioService in test environment', () {
    test('handles calls safely without platform crashes', () async {
      final service = DefaultAudioService();
      expect(service.isPlaying, isFalse);

      await service.play('rain');
      expect(service.isPlaying, isTrue);
      expect(service.currentTrack, 'rain');

      await service.pause();
      expect(service.isPlaying, isFalse);

      await service.resume();
      expect(service.isPlaying, isTrue);

      await service.setVolume(0.8);
      expect(service.volume, 0.8);

      await service.stop();
      expect(service.isPlaying, isFalse);
      expect(service.currentTrack, isNull);

      service.dispose();
    });
  });
}
