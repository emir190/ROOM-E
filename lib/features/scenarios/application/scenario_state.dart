import '../../../../core/errors/failures.dart';
import '../domain/entities/living_style_result.dart';
import '../domain/entities/scenario.dart';
import '../domain/entities/user_answer.dart';

class ScenarioState {
  final List<Scenario> scenarios;
  final int currentIndex;
  final Map<String, UserAnswer> answers;
  final String? selectedOptionId;
  final ImportanceWeight selectedImportance;
  final bool isLoading;
  final Failure? failure;
  final LivingStyleResult? result;
  final bool isFinished;
  final String additionalNotes;

  const ScenarioState({
    this.scenarios = const [],
    this.currentIndex = 0,
    this.answers = const {},
    this.selectedOptionId,
    this.selectedImportance = ImportanceWeight.important,
    this.isLoading = false,
    this.failure,
    this.result,
    this.isFinished = false,
    this.additionalNotes = '',
  });

  bool get canUnlockMatching => answers.length >= 15;
  int get answeredCount => answers.length;
  int get totalCount => scenarios.length;
  Scenario? get currentScenario =>
      scenarios.isNotEmpty && currentIndex < scenarios.length
          ? scenarios[currentIndex]
          : null;

  ScenarioState copyWith({
    List<Scenario>? scenarios,
    int? currentIndex,
    Map<String, UserAnswer>? answers,
    String? selectedOptionId,
    ImportanceWeight? selectedImportance,
    bool? isLoading,
    Failure? failure,
    LivingStyleResult? result,
    bool? isFinished,
    String? additionalNotes,
    bool clearSelected = false,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return ScenarioState(
      scenarios: scenarios ?? this.scenarios,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      selectedOptionId:
          clearSelected ? null : (selectedOptionId ?? this.selectedOptionId),
      selectedImportance: selectedImportance ?? this.selectedImportance,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      result: clearResult ? null : (result ?? this.result),
      isFinished: isFinished ?? this.isFinished,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }
}
