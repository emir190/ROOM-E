enum ImportanceWeight {
  notMuch,
  important,
  dealbreaker,
}

class UserAnswer {
  final String scenarioId;
  final String optionId;
  final ImportanceWeight importance;
  final int scenarioVersion;
  final DateTime answeredAt;

  const UserAnswer({
    required this.scenarioId,
    required this.optionId,
    required this.importance,
    this.scenarioVersion = 1,
    required this.answeredAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'scenarioId': scenarioId,
      'optionId': optionId,
      'importance': importance.name,
      'scenarioVersion': scenarioVersion,
      'answeredAt': answeredAt,
    };
  }

  factory UserAnswer.fromFirestore(Map<String, dynamic> map) {
    return UserAnswer(
      scenarioId: map['scenarioId'] as String,
      optionId: map['optionId'] as String,
      importance: ImportanceWeight.values.firstWhere(
        (i) => i.name == map['importance'],
        orElse: () => ImportanceWeight.important,
      ),
      scenarioVersion: (map['scenarioVersion'] as num?)?.toInt() ?? 1,
      answeredAt: map['answeredAt'] != null
          ? (map['answeredAt'] is DateTime
              ? map['answeredAt'] as DateTime
              : DateTime.tryParse(map['answeredAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}
