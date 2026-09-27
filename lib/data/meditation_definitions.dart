/// Data definitions for meditation tracks, breathing patterns, and durations.
library;

class AmbientTrack {
  const AmbientTrack({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.assetPath,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String assetPath;
}

/// Six ambient audio tracks bundled with Rewire (spec §4.3 and Stitch Meditasi screen).
const List<AmbientTrack> kAmbientTracks = [
  AmbientTrack(
    id: 'rain',
    title: 'Hujan',
    subtitle: 'Rintik tenang',
    emoji: '🌧️',
    assetPath: 'assets/audio/rain.mp3',
  ),
  AmbientTrack(
    id: 'waves',
    title: 'Ombak',
    subtitle: 'Debur pantai',
    emoji: '🌊',
    assetPath: 'assets/audio/ocean.mp3',
  ),
  AmbientTrack(
    id: 'forest',
    title: 'Hutan',
    subtitle: 'Angin & burung',
    emoji: '🌳',
    assetPath: 'assets/audio/forest.mp3',
  ),
  AmbientTrack(
    id: 'campfire',
    title: 'Api Unggun',
    subtitle: 'Kayu membara',
    emoji: '🔥',
    assetPath: 'assets/audio/campfire.mp3',
  ),
  AmbientTrack(
    id: 'lofi',
    title: 'Lo-fi Ambient',
    subtitle: 'Melodi hangat',
    emoji: '🎵',
    assetPath: 'assets/audio/lofi.mp3',
  ),
  AmbientTrack(
    id: 'whitenoise',
    title: 'White Noise',
    subtitle: 'Frekuensi halus',
    emoji: '📻',
    assetPath: 'assets/audio/whitenoise.mp3',
  ),
];

class BreathingPhase {
  const BreathingPhase({
    required this.label,
    required this.durationSeconds,
    required this.action, // 'inhale', 'hold', 'exhale'
  });

  final String label;
  final int durationSeconds;
  final String action;
}

class BreathingPattern {
  const BreathingPattern({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.phases,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<BreathingPhase> phases;

  int get cycleDurationSeconds =>
      phases.fold(0, (acc, phase) => acc + phase.durationSeconds);
}

/// Box Breathing: Inhale 4s -> Hold 4s -> Exhale 4s -> Hold 4s (spec §4.4).
const BreathingPattern kBoxBreathing = BreathingPattern(
  id: 'box',
  title: 'Box Breathing',
  subtitle: '4-4-4-4',
  phases: [
    BreathingPhase(
      label: 'Tarik napas...',
      durationSeconds: 4,
      action: 'inhale',
    ),
    BreathingPhase(label: 'Tahan...', durationSeconds: 4, action: 'hold'),
    BreathingPhase(
      label: 'Buang napas...',
      durationSeconds: 4,
      action: 'exhale',
    ),
    BreathingPhase(label: 'Tahan...', durationSeconds: 4, action: 'hold'),
  ],
);

/// 4-7-8 Breathing: Inhale 4s -> Hold 7s -> Exhale 8s (spec §4.4).
const BreathingPattern k478Breathing = BreathingPattern(
  id: '478',
  title: '4-7-8 Breathing',
  subtitle: 'Relax',
  phases: [
    BreathingPhase(
      label: 'Tarik napas...',
      durationSeconds: 4,
      action: 'inhale',
    ),
    BreathingPhase(label: 'Tahan...', durationSeconds: 7, action: 'hold'),
    BreathingPhase(
      label: 'Buang napas...',
      durationSeconds: 8,
      action: 'exhale',
    ),
  ],
);

const List<BreathingPattern> kBreathingPatterns = [
  kBoxBreathing,
  k478Breathing,
];

/// Standard duration options in minutes (spec §4, Stitch Meditasi screen).
const List<int> kMeditationDurations = [5, 10, 15, 20, 30];
