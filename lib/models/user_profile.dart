class UserProfile {
  const UserProfile({
    this.id,
    required this.level,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    this.streakStartDate,
    required this.brainStage,
    this.createdAt,
  });

  final int? id;
  final int level;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final String? streakStartDate;
  final String brainStage;
  final String? createdAt;

  factory UserProfile.fromMap(Map<String, Object?> map) => UserProfile(
    id: map['id'] as int?,
    level: map['level'] as int,
    totalXp: map['total_xp'] as int,
    currentStreak: map['current_streak'] as int,
    longestStreak: map['longest_streak'] as int,
    streakStartDate: map['streak_start_date'] as String?,
    brainStage: map['brain_stage'] as String,
    createdAt: map['created_at'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'level': level,
    'total_xp': totalXp,
    'current_streak': currentStreak,
    'longest_streak': longestStreak,
    'streak_start_date': streakStartDate,
    'brain_stage': brainStage,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      other is UserProfile &&
      other.id == id &&
      other.level == level &&
      other.totalXp == totalXp &&
      other.currentStreak == currentStreak &&
      other.longestStreak == longestStreak &&
      other.streakStartDate == streakStartDate &&
      other.brainStage == brainStage &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    level,
    totalXp,
    currentStreak,
    longestStreak,
    streakStartDate,
    brainStage,
    createdAt,
  );
}
