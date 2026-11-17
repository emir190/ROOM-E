import '../../../../core/errors/result.dart';
import '../entities/living_style_result.dart';
import '../entities/scenario.dart';
import '../entities/user_answer.dart';

abstract class ScenarioRepository {
  Future<Result<List<Scenario>>> getScenarios();
  Future<Result<List<UserAnswer>>> getUserAnswers(String uid);
  Future<Result<void>> saveUserAnswer(String uid, UserAnswer answer);
  Future<Result<void>> saveLivingStyleResult(String uid, LivingStyleResult result);
  Future<Result<void>> seedScenariosIfEmpty();
}
