import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roomie/core/errors/result.dart';
import 'package:roomie/features/scenarios/application/scenario_controller.dart';
import 'package:roomie/features/scenarios/data/seed/scenario_seed_data.dart';
import 'package:roomie/features/scenarios/domain/entities/living_style_result.dart';
import 'package:roomie/features/scenarios/domain/entities/user_answer.dart';
import 'package:roomie/features/scenarios/domain/repositories/scenario_repository.dart';

class MockScenarioRepository extends Mock implements ScenarioRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockScenarioRepository mockRepo;
  late ScenarioController controller;

  final testScenarios = ScenarioSeedData.allScenarios.take(5).toList();

  setUpAll(() {
    registerFallbackValue(UserAnswer(
      scenarioId: 'sc1',
      optionId: 'opt1',
      importance: ImportanceWeight.important,
      answeredAt: DateTime.now(),
    ));
    registerFallbackValue(const LivingStyleResult(
      dimensionScores: {},
      archetypeKey: 'key',
      archetypeTitleTr: '',
      archetypeTitleEn: '',
      archetypeDescriptionTr: '',
      archetypeDescriptionEn: '',
      strengthsTr: [],
      strengthsEn: [],
      cautionsTr: [],
      cautionsEn: [],
      confidence: 1.0,
      answeredCount: 15,
    ));
  });

  setUp(() {
    mockRepo = MockScenarioRepository();
    when(() => mockRepo.getScenarios())
        .thenAnswer((_) async => Success(testScenarios));
    when(() => mockRepo.getUserAnswers(any()))
        .thenAnswer((_) async => const Success([]));
    when(() => mockRepo.saveUserAnswer(any(), any()))
        .thenAnswer((_) async => const Success(null));
    when(() => mockRepo.saveLivingStyleResult(any(), any()))
        .thenAnswer((_) async => const Success(null));

    controller = ScenarioController(mockRepo, 'user_123');
  });

  tearDown(() {
    controller.dispose();
  });

  group('ScenarioController Tests', () {
    test('init loads scenarios successfully', () async {
      await controller.init();

      expect(controller.state.scenarios.length, 5);
      expect(controller.state.currentIndex, 0);
      expect(controller.state.currentScenario?.id, testScenarios[0].id);
    });

    test('selectOption and selectImportance update state', () async {
      await controller.init();

      controller.selectOption(testScenarios[0].options[1].id);
      expect(controller.state.selectedOptionId, testScenarios[0].options[1].id);

      controller.selectImportance(ImportanceWeight.dealbreaker);
      expect(controller.state.selectedImportance, ImportanceWeight.dealbreaker);
    });

    test('submitCurrentAnswer saves answer and advances to next scenario', () async {
      await controller.init();

      controller.selectOption(testScenarios[0].options[0].id);
      await controller.submitCurrentAnswer();

      expect(controller.state.currentIndex, 1);
      expect(controller.state.answeredCount, 1);
      expect(controller.state.answers.containsKey(testScenarios[0].id), isTrue);

      verify(() => mockRepo.saveUserAnswer('user_123', any())).called(1);
    });

    test('goToPrevious steps back', () async {
      await controller.init();

      controller.selectOption(testScenarios[0].options[0].id);
      await controller.submitCurrentAnswer();
      expect(controller.state.currentIndex, 1);

      controller.goToPrevious();
      expect(controller.state.currentIndex, 0);
    });

    test('anonymizeAndResetTestData clears all answers and results per KVKK', () async {
      await controller.init();

      controller.selectOption(testScenarios[0].options[0].id);
      await controller.submitCurrentAnswer();
      expect(controller.state.answeredCount, 1);

      controller.anonymizeAndResetTestData();
      expect(controller.state.answeredCount, 0);
      expect(controller.state.answers, isEmpty);
      expect(controller.state.result, isNull);
      expect(controller.state.isFinished, isFalse);
      expect(controller.state.currentIndex, 0);
    });

    test('Özellik 3: updateAdditionalNotes stores custom rules and notes at end of test', () {
      controller.updateAdditionalNotes('Gece 23:30 sonrası mutfakta sessizlik.');
      expect(
        controller.state.additionalNotes,
        'Gece 23:30 sonrası mutfakta sessizlik.',
      );
    });

    test('Özellik 4: filterScenariosByDealbreakers removes smoking and pet scenarios when unwanted', () {
      final all = ScenarioSeedData.allScenarios;
      expect(all.any((s) => s.id == 'sc_balcony_smoking'), isTrue);
      expect(all.any((s) => s.id == 'sc_pet_accident'), isTrue);

      final noSmoking = ScenarioController.filterScenariosByDealbreakers(
        all,
        smokingDealbreaker: true,
        petsDealbreaker: false,
      );
      expect(noSmoking.any((s) => s.id == 'sc_balcony_smoking'), isFalse);
      expect(noSmoking.any((s) => s.id == 'sc_pet_accident'), isTrue);

      final noPetsAndNoSmoking = ScenarioController.filterScenariosByDealbreakers(
        all,
        smokingDealbreaker: true,
        petsDealbreaker: true,
      );
      expect(noPetsAndNoSmoking.any((s) => s.id == 'sc_balcony_smoking'), isFalse);
      expect(noPetsAndNoSmoking.any((s) => s.id == 'sc_pet_accident'), isFalse);
    });
  });
}
