import 'scenario_option.dart';

class Scenario {
  final String id;
  final int version;
  final int order;
  final String category;
  final bool isActive;
  final Map<String, String> title;
  final Map<String, String> situation;
  final List<ScenarioOption> options;
  final Map<String, double> weightHints;
  final String type;

  const Scenario({
    required this.id,
    this.version = 1,
    required this.order,
    required this.category,
    this.isActive = true,
    required this.title,
    required this.situation,
    required this.options,
    required this.weightHints,
    this.type = 'single_choice',
  });

  String getLocalizedTitle(String langCode) {
    return title[langCode] ?? title['tr'] ?? title.values.first;
  }

  String getLocalizedSituation(String langCode) {
    return situation[langCode] ?? situation['tr'] ?? situation.values.first;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'version': version,
      'order': order,
      'category': category,
      'isActive': isActive,
      'title': title,
      'situation': situation,
      'options': options.map((o) => o.toMap()).toList(),
      'weightHints': weightHints,
      'type': type,
    };
  }

  factory Scenario.fromFirestore(Map<String, dynamic> map) {
    return Scenario(
      id: map['id'] as String,
      version: (map['version'] as num?)?.toInt() ?? 1,
      order: (map['order'] as num?)?.toInt() ?? 0,
      category: map['category'] as String? ?? 'general',
      isActive: map['isActive'] as bool? ?? true,
      title: (map['title'] as Map<dynamic, dynamic>).cast<String, String>(),
      situation: (map['situation'] as Map<dynamic, dynamic>).cast<String, String>(),
      options: (map['options'] as List<dynamic>)
          .map((o) => ScenarioOption.fromMap(o as Map<String, dynamic>))
          .toList(),
      weightHints: (map['weightHints'] as Map<dynamic, dynamic>).map(
        (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
      ),
      type: map['type'] as String? ?? 'single_choice',
    );
  }
}
