import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_controller.dart';
import '../../onboarding/application/onboarding_controller.dart';
import '../data/repositories/scenario_repository_impl.dart';
import '../domain/entities/scenario.dart';
import '../domain/entities/user_answer.dart';
import '../domain/repositories/scenario_repository.dart';
import '../domain/services/living_style_analyzer.dart';
import 'scenario_state.dart';

final scenarioRepositoryProvider = Provider<ScenarioRepository>((ref) {
  return ScenarioRepositoryImpl();
});

final scenarioControllerProvider =
    StateNotifierProvider<ScenarioController, ScenarioState>((ref) {
  final repository = ref.watch(scenarioRepositoryProvider);
  final authUser = ref.watch(authControllerProvider).user;
  final filters = ref.watch(
    onboardingControllerProvider.select((s) => s.data.filters),
  );
  return ScenarioController(
    repository,
    authUser?.uid,
    smokingDealbreaker: filters.smokingDealbreaker,
    petsDealbreaker: filters.petsDealbreaker,
  );
});

class ScenarioController extends StateNotifier<ScenarioState> {
  final ScenarioRepository _repository;
  final String? _uid;
  final bool _smokingDealbreaker;
  final bool _petsDealbreaker;

  ScenarioController(
    this._repository,
    this._uid, {
    bool smokingDealbreaker = false,
    bool petsDealbreaker = false,
  })  : _smokingDealbreaker = smokingDealbreaker,
        _petsDealbreaker = petsDealbreaker,
        super(const ScenarioState()) {
    init();
  }

  /// Özellik 4: Sigara veya evcil hayvan en başta istenmediğinde ilgili senaryoları çıkarır.
  static List<Scenario> filterScenariosByDealbreakers(
    List<Scenario> rawScenarios, {
    required bool smokingDealbreaker,
    required bool petsDealbreaker,
  }) {
    return rawScenarios.where((scenario) {
      if (smokingDealbreaker &&
          (scenario.id == 'sc_balcony_smoking' || scenario.id.contains('smoking'))) {
        return false;
      }
      if (petsDealbreaker &&
          (scenario.id == 'sc_pet_accident' || scenario.id.contains('pet'))) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    final scenariosResult = await _repository.getScenarios();
    final rawScenarios = scenariosResult.dataOrNull ?? [];
    final scenarios = filterScenariosByDealbreakers(
      rawScenarios,
      smokingDealbreaker: _smokingDealbreaker,
      petsDealbreaker: _petsDealbreaker,
    );

    Map<String, UserAnswer> existingAnswers = {};
    if (_uid != null) {
      final answersResult = await _repository.getUserAnswers(_uid);
      final list = answersResult.dataOrNull ?? [];
      existingAnswers = {for (final a in list) a.scenarioId: a};
    }

    // Determine initial index
    int initialIndex = 0;
    for (int i = 0; i < scenarios.length; i++) {
      if (!existingAnswers.containsKey(scenarios[i].id)) {
        initialIndex = i;
        break;
      }
    }

    // If all or at least 15 answered, check if completed
    final canComplete = existingAnswers.length >= 15;
    final isAllAnswered = scenarios.isNotEmpty && existingAnswers.length >= scenarios.length;

    final result = canComplete
        ? LivingStyleAnalyzer.computeResult(
            scenarios: scenarios,
            answers: existingAnswers.values.toList(),
          )
        : null;

    final currentScenario =
        scenarios.isNotEmpty && initialIndex < scenarios.length ? scenarios[initialIndex] : null;
    final existingAnswer = currentScenario != null ? existingAnswers[currentScenario.id] : null;

    state = state.copyWith(
      scenarios: scenarios,
      currentIndex: initialIndex,
      answers: existingAnswers,
      selectedOptionId: existingAnswer?.optionId,
      selectedImportance: existingAnswer?.importance ?? ImportanceWeight.important,
      isLoading: false,
      result: result,
      isFinished: isAllAnswered,
    );
  }

  void selectOption(String optionId) {
    HapticFeedback.lightImpact();
    state = state.copyWith(selectedOptionId: optionId);
  }

  void selectImportance(ImportanceWeight importance) {
    HapticFeedback.selectionClick();
    state = state.copyWith(selectedImportance: importance);
  }

  /// Özellik 3: Senaryo sonunda kullanıcının eklemek istediği kurallar / dikkat edilmesi gerekenler notu
  void updateAdditionalNotes(String notes) {
    state = state.copyWith(additionalNotes: notes);
  }

  Future<void> submitCurrentAnswer() async {
    final current = state.currentScenario;
    if (current == null || state.selectedOptionId == null) return;

    final answer = UserAnswer(
      scenarioId: current.id,
      optionId: state.selectedOptionId!,
      importance: state.selectedImportance,
      scenarioVersion: current.version,
      answeredAt: DateTime.now(),
    );

    final updatedAnswers = Map<String, UserAnswer>.from(state.answers)
      ..[current.id] = answer;

    state = state.copyWith(answers: updatedAnswers);

    // Save in background to Firestore
    if (_uid != null) {
      unawaited(_repository.saveUserAnswer(_uid, answer));
    }

    // Move to next question or finalize
    if (state.currentIndex < state.scenarios.length - 1) {
      final nextIndex = state.currentIndex + 1;
      final nextScenario = state.scenarios[nextIndex];
      final nextExisting = state.answers[nextScenario.id];

      state = state.copyWith(
        currentIndex: nextIndex,
        selectedOptionId: nextExisting?.optionId,
        selectedImportance: nextExisting?.importance ?? ImportanceWeight.important,
      );
    } else {
      // Finished all scenarios!
      await finishTest();
    }
  }

  void goToPrevious() {
    if (state.currentIndex > 0) {
      final prevIndex = state.currentIndex - 1;
      final prevScenario = state.scenarios[prevIndex];
      final prevExisting = state.answers[prevScenario.id];

      state = state.copyWith(
        currentIndex: prevIndex,
        selectedOptionId: prevExisting?.optionId,
        selectedImportance: prevExisting?.importance ?? ImportanceWeight.important,
      );
    }
  }

  Future<void> finishTest() async {
    if (!state.canUnlockMatching) return;

    state = state.copyWith(isLoading: true);

    final result = LivingStyleAnalyzer.computeResult(
      scenarios: state.scenarios,
      answers: state.answers.values.toList(),
    );

    if (_uid != null) {
      await _repository.saveLivingStyleResult(_uid, result);
    }

    state = state.copyWith(
      isLoading: false,
      result: result,
      isFinished: true,
    );
  }

  void retakeTest() {
    state = state.copyWith(
      currentIndex: 0,
      clearSelected: true,
      selectedImportance: ImportanceWeight.important,
      isFinished: false,
    );
  }

  /// KVKK Madde 7 & 11: Kullanıcının test yanıtlarını ve kapalı kutu vektörünü sıfırlama / anonimleştirme
  void anonymizeAndResetTestData() {
    state = state.copyWith(
      currentIndex: 0,
      answers: const <String, UserAnswer>{},
      clearSelected: true,
      clearResult: true,
      selectedImportance: ImportanceWeight.important,
      isFinished: false,
    );
  }
}
