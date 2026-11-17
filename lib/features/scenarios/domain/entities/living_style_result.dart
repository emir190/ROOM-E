class DimensionScore {
  final String key;
  final String labelTr;
  final String labelEn;
  final double score; // 0.0 to 100.0

  const DimensionScore({
    required this.key,
    required this.labelTr,
    required this.labelEn,
    required this.score,
  });

  String getLocalizedLabel(String langCode) {
    return langCode == 'tr' ? labelTr : labelEn;
  }
}

class LivingStyleResult {
  final Map<String, double> dimensionScores; // 10 dimensions, 0..100
  final String archetypeKey;
  final String archetypeTitleTr;
  final String archetypeTitleEn;
  final String archetypeDescriptionTr;
  final String archetypeDescriptionEn;
  final List<String> strengthsTr;
  final List<String> strengthsEn;
  final List<String> cautionsTr;
  final List<String> cautionsEn;
  final double confidence; // 0.0 .. 1.0 based on answers count
  final int answeredCount;

  const LivingStyleResult({
    required this.dimensionScores,
    required this.archetypeKey,
    required this.archetypeTitleTr,
    required this.archetypeTitleEn,
    required this.archetypeDescriptionTr,
    required this.archetypeDescriptionEn,
    required this.strengthsTr,
    required this.strengthsEn,
    required this.cautionsTr,
    required this.cautionsEn,
    required this.confidence,
    required this.answeredCount,
  });

  Map<String, dynamic> toFirestoreVector() {
    return {
      ...dimensionScores,
      'confidence': confidence,
      'answeredCount': answeredCount,
      'archetypeKey': archetypeKey,
    };
  }
}
