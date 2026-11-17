import 'package:flutter_test/flutter_test.dart';
import 'package:roomie/features/scenarios/data/seed/scenario_seed_data.dart';
import 'package:roomie/features/scenarios/domain/services/living_style_analyzer.dart';

void main() {
  group('ScenarioSeedData Integrity Tests', () {
    final scenarios = ScenarioSeedData.allScenarios;

    test('Contains at least 30 scenarios (found ${scenarios.length})', () {
      expect(scenarios.length, greaterThanOrEqualTo(30));
    });

    test('All scenario IDs and orders are unique', () {
      final ids = scenarios.map((s) => s.id).toSet();
      expect(ids.length, scenarios.length);

      final orders = scenarios.map((s) => s.order).toSet();
      expect(orders.length, scenarios.length);
    });

    test('All scenarios have valid Turkish and English titles and situations', () {
      for (final s in scenarios) {
        expect(s.title['tr'], isNotEmpty, reason: '${s.id} missing TR title');
        expect(s.title['en'], isNotEmpty, reason: '${s.id} missing EN title');
        expect(s.situation['tr'], isNotEmpty, reason: '${s.id} missing TR situation');
        expect(s.situation['en'], isNotEmpty, reason: '${s.id} missing EN situation');
      }
    });

    test('All scenarios have at least 3 non-judgmental options with valid dimension effects', () {
      final validDims = LivingStyleAnalyzer.allDimensions.toSet();

      for (final s in scenarios) {
        expect(s.options.length, greaterThanOrEqualTo(3),
            reason: '${s.id} should have >= 3 options');

        for (final opt in s.options) {
          expect(opt.text['tr'], isNotEmpty, reason: '${opt.id} missing TR text');
          expect(opt.text['en'], isNotEmpty, reason: '${opt.id} missing EN text');
          expect(opt.effects, isNotEmpty, reason: '${opt.id} missing effects');

          for (final effectEntry in opt.effects.entries) {
            expect(validDims.contains(effectEntry.key), isTrue,
                reason: 'Unknown dimension ${effectEntry.key} in ${opt.id}');
            expect(effectEntry.value, inInclusiveRange(-2.0, 2.0),
                reason: 'Effect ${effectEntry.value} out of range [-2, 2] in ${opt.id}');
          }
        }
      }
    });
  });
}
