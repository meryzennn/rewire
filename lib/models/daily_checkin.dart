class DailyCheckin {
  const DailyCheckin({
    this.id,
    required this.date,
    required this.status,
    this.mood,
    this.notes,
    required this.xpEarned,
    this.createdAt,
  });

  final int? id;
  final String date;
  final String status;
  final int? mood;
  final String? notes;
  final int xpEarned;
  final String? createdAt;

  factory DailyCheckin.fromMap(Map<String, Object?> map) => DailyCheckin(
    id: map['id'] as int?,
    date: map['date'] as String,
    status: map['status'] as String,
    mood: map['mood'] as int?,
    notes: map['notes'] as String?,
    xpEarned: map['xp_earned'] as int,
    createdAt: map['created_at'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'date': date,
    'status': status,
    'mood': mood,
    'notes': notes,
    'xp_earned': xpEarned,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      other is DailyCheckin &&
      other.id == id &&
      other.date == date &&
      other.status == status &&
      other.mood == mood &&
      other.notes == notes &&
      other.xpEarned == xpEarned &&
      other.createdAt == createdAt;

  @override
  int get hashCode =>
      Object.hash(id, date, status, mood, notes, xpEarned, createdAt);
}
