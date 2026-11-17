import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/living_style_result.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/entities/user_answer.dart';
import '../../domain/repositories/scenario_repository.dart';
import '../seed/scenario_seed_data.dart';

class ScenarioRepositoryImpl implements ScenarioRepository {
  final FirebaseFirestore _firestore;
  static final Map<String, List<UserAnswer>> _answersCache = {};
  static final Map<String, LivingStyleResult> _resultsCache = {};

  ScenarioRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Result<List<Scenario>>> getScenarios() async {
    // Return bundled seed scenarios instantly
    return Success(ScenarioSeedData.allScenarios);
  }

  @override
  Future<Result<List<UserAnswer>>> getUserAnswers(String uid) async {
    if (uid.startsWith('demo_user_')) {
      return Success(_answersCache[uid] ?? []);
    }
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('answers')
          .get()
          .timeout(const Duration(seconds: 2));

      final answers = snapshot.docs
          .map((doc) => UserAnswer.fromFirestore(doc.data()))
          .toList();
      _answersCache[uid] = answers;
      return Success(answers);
    } catch (_) {
      return Success(_answersCache[uid] ?? []);
    }
  }

  @override
  Future<Result<void>> saveUserAnswer(String uid, UserAnswer answer) async {
    final list = _answersCache[uid] ?? [];
    list.removeWhere((a) => a.scenarioId == answer.scenarioId);
    list.add(answer);
    _answersCache[uid] = list;

    if (uid.startsWith('demo_user_')) {
      return const Success(null);
    }
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('answers')
          .doc(answer.scenarioId)
          .set(
            {
              ...answer.toFirestore(),
              'answeredAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          )
          .timeout(const Duration(seconds: 2));
      return const Success(null);
    } catch (_) {
      return const Success(null);
    }
  }

  @override
  Future<Result<void>> saveLivingStyleResult(
      String uid, LivingStyleResult result) async {
    _resultsCache[uid] = result;
    if (uid.startsWith('demo_user_')) {
      return const Success(null);
    }
    try {
      // KVKK Compliant: Write raw vector to isolated server-only privateVectors collection
      // and store only non-sensitive completion metadata on user document.
      await _firestore.collection('privateVectors').doc(uid).set(
        {
          ...result.toFirestoreVector(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      ).timeout(const Duration(seconds: 2));

      await _firestore.collection('users').doc(uid).set(
        {
          'kvkkBlindVectorReady': true,
          'answeredCount': result.answeredCount,
          'onboardingStep': 'completed',
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      ).timeout(const Duration(seconds: 2));
      return const Success(null);
    } catch (_) {
      return const Success(null);
    }
  }

  @override
  Future<Result<void>> seedScenariosIfEmpty() async {
    try {
      final existing = await _firestore.collection('scenarios').limit(1).get().timeout(const Duration(seconds: 2));
      if (existing.docs.isNotEmpty) {
        return const Success(null);
      }

      final batch = _firestore.batch();
      for (final scenario in ScenarioSeedData.allScenarios) {
        final ref = _firestore.collection('scenarios').doc(scenario.id);
        batch.set(ref, scenario.toFirestore());
      }
      await batch.commit();
      return const Success(null);
    } catch (e) {
      return const Success(null);
    }
  }
}
