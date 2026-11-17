import 'dart:math';
import '../entities/living_style_result.dart';
import '../entities/scenario.dart';
import '../entities/user_answer.dart';

class LivingStyleAnalyzer {
  LivingStyleAnalyzer._();

  static const List<String> allDimensions = [
    'cleanliness',
    'noise_tolerance',
    'sleep_schedule',
    'social_energy',
    'guest_policy',
    'chore_fairness',
    'money_style',
    'conflict_style',
    'privacy_need',
    'responsibility',
  ];

  static LivingStyleResult computeResult({
    required List<Scenario> scenarios,
    required List<UserAnswer> answers,
  }) {
    final Map<String, double> scores = {
      for (final dim in allDimensions) dim: 50.0,
    };

    final Map<String, double> deltaSums = {
      for (final dim in allDimensions) dim: 0.0,
    };
    final Map<String, double> weightSums = {
      for (final dim in allDimensions) dim: 0.0,
    };

    final scenarioMap = {for (final s in scenarios) s.id: s};

    for (final answer in answers) {
      final scenario = scenarioMap[answer.scenarioId];
      if (scenario == null) continue;

      final option = scenario.options.firstWhere(
        (o) => o.id == answer.optionId,
        orElse: () => scenario.options.first,
      );

      final importanceMultiplier = switch (answer.importance) {
        ImportanceWeight.notMuch => 0.75,
        ImportanceWeight.important => 1.25,
        ImportanceWeight.dealbreaker => 2.0,
      };

      for (final entry in option.effects.entries) {
        final dim = entry.key;
        final rawDelta = entry.value; // -2.0 .. +2.0
        final hint = scenario.weightHints[dim] ?? 0.8;
        final effectiveWeight = hint * importanceMultiplier;

        deltaSums[dim] = (deltaSums[dim] ?? 0.0) + (rawDelta * effectiveWeight);
        weightSums[dim] = (weightSums[dim] ?? 0.0) + effectiveWeight;
      }
    }

    for (final dim in allDimensions) {
      final totalWeight = weightSums[dim] ?? 0.0;
      if (totalWeight > 0.0) {
        final avgDelta = (deltaSums[dim] ?? 0.0) / totalWeight; // -2.0 .. +2.0
        // Map delta (-2.0 .. +2.0) to 0 .. 100 with baseline 50
        final normalizedScore = 50.0 + (avgDelta * 25.0);
        scores[dim] = normalizedScore.clamp(0.0, 100.0);
      }
    }

    final answeredCount = answers.length;
    final confidence = min(1.0, answeredCount / 15.0);

    final archetype = _determineArchetype(scores);
    final insights = _generateInsights(scores);

    return LivingStyleResult(
      dimensionScores: scores,
      archetypeKey: archetype.key,
      archetypeTitleTr: archetype.titleTr,
      archetypeTitleEn: archetype.titleEn,
      archetypeDescriptionTr: archetype.descTr,
      archetypeDescriptionEn: archetype.descEn,
      strengthsTr: insights.strengthsTr,
      strengthsEn: insights.strengthsEn,
      cautionsTr: insights.cautionsTr,
      cautionsEn: insights.cautionsEn,
      confidence: confidence,
      answeredCount: answeredCount,
    );
  }

  static ({
    String key,
    String titleTr,
    String titleEn,
    String descTr,
    String descEn
  }) _determineArchetype(Map<String, double> scores) {
    final clean = scores['cleanliness'] ?? 50.0;
    final resp = scores['responsibility'] ?? 50.0;
    final social = scores['social_energy'] ?? 50.0;
    final guest = scores['guest_policy'] ?? 50.0;
    final sleep = scores['sleep_schedule'] ?? 50.0;
    final noise = scores['noise_tolerance'] ?? 50.0;
    final privacy = scores['privacy_need'] ?? 50.0;
    final conflict = scores['conflict_style'] ?? 50.0;
    final chore = scores['chore_fairness'] ?? 50.0;

    if (clean >= 68 && resp >= 65) {
      return (
        key: 'organized_pillar',
        titleTr: 'Düzen Abidesi',
        titleEn: 'The Organized Pillar',
        descTr: 'Evin direği; planlı, temizlik standartları yüksek ve sorumluluklarında son derece dakik.',
        descEn: 'A dependable rock: clean, punctual with commitments, and highly organized.',
      );
    } else if (social >= 65 && guest >= 65) {
      return (
        key: 'welcoming_host',
        titleTr: 'Sıcakkanlı Ev Sahibi',
        titleEn: 'The Welcoming Host',
        descTr: 'Evi bir yaşam ve neşe alanı olarak gören, misafiri ve ortak anları seven sosyal karakter.',
        descEn: 'Views home as a vibrant community hub, welcoming guests and spontaneous shared meals.',
      );
    } else if (privacy >= 68 && noise <= 40) {
      return (
        key: 'zen_sanctuary',
        titleTr: 'Huzur Arayan',
        titleEn: 'The Zen Sanctuary',
        descTr: 'Evi dış dünyanın karmaşasından kaçtığı sessiz ve huzurlu bir sığınak olarak gören sakin ruh.',
        descEn: 'Values quiet personal space, low-noise sanctuary, and respectful boundaries above all.',
      );
    } else if (sleep >= 65 && noise >= 55) {
      return (
        key: 'creative_night_owl',
        titleTr: 'Yaratıcı Gece Kuşu',
        titleEn: 'The Creative Night Owl',
        descTr: 'Gece saatlerinde canlanan, esnek gürültü toleransına sahip rahat bir ev arkadaşı.',
        descEn: 'Thrives in evening hours, relaxed about ambient chatter and casual domestic rhythm.',
      );
    } else if (conflict >= 65 && chore >= 65) {
      return (
        key: 'direct_realist',
        titleTr: 'Açık Sözlü İlkeli',
        titleEn: 'The Direct Realist',
        descTr: 'Sorunları biriktirmeden açıkça konuşan, hakkaniyetli iş bölümüne değer veren net karakter.',
        descEn: 'Addresses friction transparently on the spot with strong commitment to fair chore division.',
      );
    } else {
      return (
        key: 'balanced_companion',
        titleTr: 'Dengeli Ev Arkadaşı',
        titleEn: 'The Balanced Companion',
        descTr: 'Farklı yaşam tarzlarına uyum sağlayabilen, ne aşırı kuralcı ne de dağınık olan uyumlu profil.',
        descEn: 'Adaptable and considerate, striking a healthy balance between solitude and shared moments.',
      );
    }
  }

  static ({
    List<String> strengthsTr,
    List<String> strengthsEn,
    List<String> cautionsTr,
    List<String> cautionsEn,
  }) _generateInsights(Map<String, double> scores) {
    final List<String> sTr = [];
    final List<String> sEn = [];
    final List<String> cTr = [];
    final List<String> cEn = [];

    // Cleanliness
    if ((scores['cleanliness'] ?? 50) >= 60) {
      sTr.add('Ortak alan ve mutfak hijyenine özen gösterir.');
      sEn.add('Maintains high standards of kitchen and common area tidiness.');
    } else if ((scores['cleanliness'] ?? 50) <= 40) {
      cTr.add('Aşırı titiz ev arkadaşlarıyla temizlik sıklığı konusunda sürtüşme yaşayabilir.');
      cEn.add('May experience friction with ultra-strict clean freaks over cleaning frequency.');
    }

    // Noise
    if ((scores['noise_tolerance'] ?? 50) >= 60) {
      sTr.add('Gürültüye toleranslıdır; ev içindeki canlılıktan rahatsız olmaz.');
      sEn.add('Tolerant of ambient domestic noise and daytime music.');
    } else if ((scores['noise_tolerance'] ?? 50) <= 40) {
      cTr.add('Gece geç saatteki seslere ve ani gürültülere karşı hassastır.');
      cEn.add('Sensitive to late-night noise or sudden loud gatherings.');
    }

    // Responsibility & Money
    if ((scores['responsibility'] ?? 50) >= 60) {
      sTr.add('Kira, fatura ve ortak taahhütlerde güvenilirdir.');
      sEn.add('Reliable and punctual with rent and utility payments.');
    }

    if ((scores['privacy_need'] ?? 50) >= 60) {
      cTr.add('Kişisel eşyaların izinsiz paylaşılması konusunda katı sınırlara sahiptir.');
      cEn.add('Has strict personal boundaries regarding borrowing belongings without permission.');
    }

    // Conflict
    if ((scores['conflict_style'] ?? 50) >= 60) {
      sTr.add('Sorunları içine atmak yerine doğrudan ve yapıcı şekilde konuşur.');
      sEn.add('Resolves misunderstandings directly and constructively without passive aggression.');
    } else if ((scores['conflict_style'] ?? 50) <= 40) {
      cTr.add('Huzursuzluk çıkmasın diye rahatsızlığını geciktirip içine atabilir.');
      cEn.add('Tends to internalize minor grievances rather than speaking up immediately.');
    }

    // Ensure at least 3 strengths and 2 cautions
    final defaultStrengthsTr = [
      'Ev arkadaşının yaşam alanına ve özgürlüğüne saygı duyar.',
      'Ortak yaşamda işbirliğine ve çözüme açıktır.',
      'Ev içindeki huzuru ve karşılıklı anlayışı önemser.',
    ];
    final defaultStrengthsEn = [
      'Respects the personal freedom and boundaries of their roommate.',
      'Open to constructive compromise and cooperative living.',
      'Values domestic harmony and mutual understanding.',
    ];

    for (int i = 0; i < defaultStrengthsTr.length && sTr.length < 3; i++) {
      if (!sTr.contains(defaultStrengthsTr[i])) {
        sTr.add(defaultStrengthsTr[i]);
        sEn.add(defaultStrengthsEn[i]);
      }
    }

    final defaultCautionsTr = [
      'İletişimde beklentilerin baştan net konuşulması önemlidir.',
      'Yoğun sınav ve çalışma dönemlerinde sessizlik ihtiyacı artar.',
    ];
    final defaultCautionsEn = [
      'Clear mutual expectations must be aligned early to prevent misunderstandings.',
      'Quiet space needs increase substantially during exam and peak work cycles.',
    ];

    for (int i = 0; i < defaultCautionsTr.length && cTr.length < 2; i++) {
      if (!cTr.contains(defaultCautionsTr[i])) {
        cTr.add(defaultCautionsTr[i]);
        cEn.add(defaultCautionsEn[i]);
      }
    }

    return (
      strengthsTr: sTr.take(3).toList(),
      strengthsEn: sEn.take(3).toList(),
      cautionsTr: cTr.take(2).toList(),
      cautionsEn: cEn.take(2).toList(),
    );
  }
}
