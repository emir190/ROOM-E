import 'package:flutter_test/flutter_test.dart';
import 'package:roomie/features/scenarios/data/seed/scenario_seed_data.dart';
import 'package:roomie/features/scenarios/domain/entities/user_answer.dart';
import 'package:roomie/features/scenarios/domain/services/living_style_analyzer.dart';

void main() {
  group('LivingStyleAnalyzer Tests', () {
    final scenarios = ScenarioSeedData.allScenarios;

    test('empty answers returns baseline 50 for all 10 dimensions', () {
      final result = LivingStyleAnalyzer.computeResult(
        scenarios: scenarios,
        answers: [],
      );

      expect(result.dimensionScores.length, 10);
      for (final dim in LivingStyleAnalyzer.allDimensions) {
        expect(result.dimensionScores[dim], 50.0);
      }
      expect(result.confidence, 0.0);
      expect(result.answeredCount, 0);
      expect(result.strengthsTr.length, 3);
      expect(result.cautionsTr.length, 2);
    });

    test('high cleanliness answers produce high cleanliness score (> 70)', () {
      final answers = [
        UserAnswer(
          scenarioId: 'sc_dishes_3days',
          optionId: 'sc_dishes_a', // cleanliness: +1.5
          importance: ImportanceWeight.dealbreaker,
          answeredAt: DateTime.now(),
        ),
        UserAnswer(
          scenarioId: 'sc_cleaning_day',
          optionId: 'sc_clean_a', // cleanliness: +1.6
          importance: ImportanceWeight.dealbreaker,
          answeredAt: DateTime.now(),
        ),
        UserAnswer(
          scenarioId: 'sc_shoes_indoors',
          optionId: 'sc_shoes_a', // cleanliness: +2.0
          importance: ImportanceWeight.dealbreaker,
          answeredAt: DateTime.now(),
        ),
      ];

      final result = LivingStyleAnalyzer.computeResult(
        scenarios: scenarios,
        answers: answers,
      );

      final cleanScore = result.dimensionScores['cleanliness']!;
      expect(cleanScore, greaterThan(70.0));
      expect(cleanScore, lessThanOrEqualTo(100.0));
    });

    test('15 answers yields confidence of 1.0', () {
      final answers = List.generate(
        15,
        (i) => UserAnswer(
          scenarioId: scenarios[i].id,
          optionId: scenarios[i].options.first.id,
          importance: ImportanceWeight.important,
          answeredAt: DateTime.now(),
        ),
      );

      final result = LivingStyleAnalyzer.computeResult(
        scenarios: scenarios,
        answers: answers,
      );

      expect(result.confidence, 1.0);
      expect(result.answeredCount, 15);
    });
  });
}
