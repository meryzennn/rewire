class TriggerEntry {
  const TriggerEntry({
    this.id,
    required this.date,
    required this.description,
    this.createdAt,
  });

  final int? id;
  final String date;
  final String description;
  final String? createdAt;

  factory TriggerEntry.fromMap(Map<String, Object?> map) => TriggerEntry(
    id: map['id'] as int?,
    date: map['date'] as String,
    description: map['description'] as String,
    createdAt: map['created_at'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'date': date,
    'description': description,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      other is TriggerEntry &&
      other.id == id &&
      other.date == date &&
      other.description == description &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, date, description, createdAt);
}
