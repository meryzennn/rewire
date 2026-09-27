class Achievement {
  const Achievement({
    this.id,
    required this.badgeId,
    required this.title,
    this.description,
    this.icon,
    required this.unlocked,
    this.dateUnlocked,
    this.createdAt,
  });

  final int? id;
  final String badgeId;
  final String title;
  final String? description;
  final String? icon;
  final int unlocked;
  final String? dateUnlocked;
  final String? createdAt;

  factory Achievement.fromMap(Map<String, Object?> map) => Achievement(
    id: map['id'] as int?,
    badgeId: map['badge_id'] as String,
    title: map['title'] as String,
    description: map['description'] as String?,
    icon: map['icon'] as String?,
    unlocked: map['unlocked'] as int,
    dateUnlocked: map['date_unlocked'] as String?,
    createdAt: map['created_at'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'badge_id': badgeId,
    'title': title,
    'description': description,
    'icon': icon,
    'unlocked': unlocked,
    'date_unlocked': dateUnlocked,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      other is Achievement &&
      other.id == id &&
      other.badgeId == badgeId &&
      other.title == title &&
      other.description == description &&
      other.icon == icon &&
      other.unlocked == unlocked &&
      other.dateUnlocked == dateUnlocked &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    badgeId,
    title,
    description,
    icon,
    unlocked,
    dateUnlocked,
    createdAt,
  );
}
