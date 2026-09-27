class Streak {
  const Streak({
    this.id,
    required this.startDate,
    this.endDate,
    required this.length,
    this.endedBy,
    this.createdAt,
  });

  final int? id;
  final String startDate;
  final String? endDate;
  final int length;
  final String? endedBy;
  final String? createdAt;

  factory Streak.fromMap(Map<String, Object?> map) => Streak(
    id: map['id'] as int?,
    startDate: map['start_date'] as String,
    endDate: map['end_date'] as String?,
    length: map['length'] as int,
    endedBy: map['ended_by'] as String?,
    createdAt: map['created_at'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'start_date': startDate,
    'end_date': endDate,
    'length': length,
    'ended_by': endedBy,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      other is Streak &&
      other.id == id &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.length == length &&
      other.endedBy == endedBy &&
      other.createdAt == createdAt;

  @override
  int get hashCode =>
      Object.hash(id, startDate, endDate, length, endedBy, createdAt);
}
