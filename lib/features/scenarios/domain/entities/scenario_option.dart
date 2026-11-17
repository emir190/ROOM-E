class ScenarioOption {
  final String id;
  final Map<String, String> text; // {'tr': '...', 'en': '...'}
  final Map<String, double> effects; // {'cleanliness': 1.5, 'conflict_style': -1.0}

  const ScenarioOption({
    required this.id,
    required this.text,
    required this.effects,
  });

  String getLocalizedText(String langCode) {
    return text[langCode] ?? text['tr'] ?? text.values.first;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'effects': effects,
    };
  }

  factory ScenarioOption.fromMap(Map<String, dynamic> map) {
    return ScenarioOption(
      id: map['id'] as String,
      text: (map['text'] as Map<dynamic, dynamic>).cast<String, String>(),
      effects: (map['effects'] as Map<dynamic, dynamic>).map(
        (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
      ),
    );
  }
}
