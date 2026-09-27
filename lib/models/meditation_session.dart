class MeditationSession {
  const MeditationSession({
    this.id,
    required this.date,
    required this.durationSeconds,
    this.audioType,
    this.breathingType,
    required this.xpEarned,
    required this.completed,
    this.createdAt,
  });

  final int? id;
  final String date;
  final int durationSeconds;
  final String? audioType;
  final String? breathingType;
  final int xpEarned;
  final int completed;
  final String? createdAt;

  factory MeditationSession.fromMap(Map<String, Object?> map) =>
      MeditationSession(
        id: map['id'] as int?,
        date: map['date'] as String,
        durationSeconds: map['duration_seconds'] as int,
        audioType: map['audio_type'] as String?,
        breathingType: map['breathing_type'] as String?,
        xpEarned: map['xp_earned'] as int,
        completed: map['completed'] as int,
        createdAt: map['created_at'] as String?,
      );

  Map<String, Object?> toMap() => {
    'id': id,
    'date': date,
    'duration_seconds': durationSeconds,
    'audio_type': audioType,
    'breathing_type': breathingType,
    'xp_earned': xpEarned,
    'completed': completed,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      other is MeditationSession &&
      other.id == id &&
      other.date == date &&
      other.durationSeconds == durationSeconds &&
      other.audioType == audioType &&
      other.breathingType == breathingType &&
      other.xpEarned == xpEarned &&
      other.completed == completed &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    date,
    durationSeconds,
    audioType,
    breathingType,
    xpEarned,
    completed,
    createdAt,
  );
}
