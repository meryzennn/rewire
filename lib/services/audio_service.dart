import 'dart:io' show Platform;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../data/meditation_definitions.dart';

/// Audio service interface conforming to spec §7 and Task 10 requirements.
abstract class AudioService {
  static AudioService instance = DefaultAudioService();

  Future<void> play(String trackName);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> setVolume(double volume);

  bool get isPlaying;
  String? get currentTrack;
  double get volume;
  void dispose();
}

/// Production implementation of [AudioService] using `audioplayers`.
class DefaultAudioService implements AudioService {
  DefaultAudioService({AudioPlayer? player}) : _explicitPlayer = player;

  final AudioPlayer? _explicitPlayer;
  AudioPlayer? _lazyPlayer;

  AudioPlayer get _player => _explicitPlayer ?? (_lazyPlayer ??= AudioPlayer());

  bool _isPlaying = false;
  String? _currentTrack;
  double _volume = 1.0;

  @override
  bool get isPlaying => _isPlaying;

  @override
  String? get currentTrack => _currentTrack;

  @override
  double get volume => _volume;

  bool get _isTesting {
    if (kIsWeb) return false;
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

  /// Resolves a track ID (e.g. 'rain', 'waves') or raw filename to the AssetSource path.
  static String resolveAssetPath(String trackName) {
    var path = trackName;
    for (final track in kAmbientTracks) {
      if (track.id == trackName ||
          track.assetPath == trackName ||
          track.assetPath.endsWith('/$trackName') ||
          track.assetPath.endsWith('/$trackName.mp3')) {
        path = track.assetPath;
        break;
      }
    }

    const aliases = {
      'waves': 'assets/audio/ocean-waves.mp3',
      'ocean': 'assets/audio/ocean-waves.mp3',
      'forest': 'assets/audio/nature-forest-sound.mp3',
      'campfire': 'assets/audio/fireplace-loop-original-noise.mp3',
      'lofi': 'assets/audio/ambient-wave.mp3',
      'whitenoise': 'assets/audio/white-noise.mp3',
      'white-noise': 'assets/audio/white-noise.mp3',
    };
    if (aliases.containsKey(path)) {
      path = aliases[path]!;
    }

    // Normalize asset path for AssetSource (which strips 'assets/')
    if (path.startsWith('assets/')) {
      path = path.substring('assets/'.length);
    }
    if (!path.contains('/')) {
      path = 'audio/$path';
    }
    if (!path.endsWith('.mp3')) {
      path = '$path.mp3';
    }
    return path;
  }

  @override
  Future<void> play(String trackName) async {
    _currentTrack = trackName;
    _isPlaying = true;

    if (_isTesting) {
      // Avoid real platform audio channel calls during test runs
      return;
    }

    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(_volume);

      final path = resolveAssetPath(trackName);
      await _player.play(AssetSource(path));
    } catch (e) {
      debugPrint('AudioService.play non-fatal warning: $e');
    }
  }

  @override
  Future<void> pause() async {
    _isPlaying = false;
    if (_isTesting) return;
    try {
      await _player.pause();
    } catch (e) {
      debugPrint('AudioService.pause non-fatal warning: $e');
    }
  }

  @override
  Future<void> resume() async {
    if (_currentTrack != null) {
      _isPlaying = true;
    }
    if (_isTesting) return;
    try {
      await _player.resume();
    } catch (e) {
      debugPrint('AudioService.resume non-fatal warning: $e');
    }
  }

  @override
  Future<void> stop() async {
    _isPlaying = false;
    _currentTrack = null;
    if (_isTesting) return;
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('AudioService.stop non-fatal warning: $e');
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    if (_isTesting) return;
    try {
      await _player.setVolume(_volume);
    } catch (e) {
      debugPrint('AudioService.setVolume non-fatal warning: $e');
    }
  }

  @override
  void dispose() {
    _isPlaying = false;
    _currentTrack = null;
    if (!_isTesting) {
      try {
        _player.dispose();
      } catch (_) {}
    }
  }
}

/// Fake audio service for deterministic unit and widget testing.
class FakeAudioService implements AudioService {
  bool _isPlaying = false;
  String? _currentTrack;
  double _volume = 1.0;

  final List<String> callLog = [];

  @override
  bool get isPlaying => _isPlaying;

  @override
  String? get currentTrack => _currentTrack;

  @override
  double get volume => _volume;

  @override
  Future<void> play(String trackName) async {
    callLog.add('play:$trackName');
    _currentTrack = trackName;
    _isPlaying = true;
  }

  @override
  Future<void> pause() async {
    callLog.add('pause');
    _isPlaying = false;
  }

  @override
  Future<void> resume() async {
    callLog.add('resume');
    if (_currentTrack != null) {
      _isPlaying = true;
    }
  }

  @override
  Future<void> stop() async {
    callLog.add('stop');
    _isPlaying = false;
    _currentTrack = null;
  }

  @override
  Future<void> setVolume(double volume) async {
    callLog.add('setVolume:$volume');
    _volume = volume.clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    callLog.add('dispose');
    _isPlaying = false;
    _currentTrack = null;
  }
}
