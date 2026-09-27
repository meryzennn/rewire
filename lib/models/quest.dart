class Quest {
  const Quest({
    this.id,
    required this.questId,
    required this.type,
    required this.title,
    this.description,
    required this.xpReward,
    required this.targetValue,
    required this.currentValue,
    required this.completed,
    required this.dateAssigned,
    this.dateCompleted,
    this.createdAt,
  });

  final int? id;
  final String questId;
  final String type;
  final String title;
  final String? description;
  final int xpReward;
  final int targetValue;
  final int currentValue;
  final int completed;
  final String dateAssigned;
  final String? dateCompleted;
  final String? createdAt;

  factory Quest.fromMap(Map<String, Object?> map) => Quest(
    id: map['id'] as int?,
    questId: map['quest_id'] as String,
    type: map['type'] as String,
    title: map['title'] as String,
    description: map['description'] as String?,
    xpReward: map['xp_reward'] as int,
    targetValue: map['target_value'] as int,
    currentValue: map['current_value'] as int,
    completed: map['completed'] as int,
    dateAssigned: map['date_assigned'] as String,
    dateCompleted: map['date_completed'] as String?,
    createdAt: map['created_at'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'quest_id': questId,
    'type': type,
    'title': title,
    'description': description,
    'xp_reward': xpReward,
    'target_value': targetValue,
    'current_value': currentValue,
    'completed': completed,
    'date_assigned': dateAssigned,
    'date_completed': dateCompleted,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      other is Quest &&
      other.id == id &&
      other.questId == questId &&
      other.type == type &&
      other.title == title &&
      other.description == description &&
      other.xpReward == xpReward &&
      other.targetValue == targetValue &&
      other.currentValue == currentValue &&
      other.completed == completed &&
      other.dateAssigned == dateAssigned &&
      other.dateCompleted == dateCompleted &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    questId,
    type,
    title,
    description,
    xpReward,
    targetValue,
    currentValue,
    completed,
    dateAssigned,
    dateCompleted,
    createdAt,
  );
}
