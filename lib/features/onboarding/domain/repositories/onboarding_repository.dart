import 'dart:io';
import '../../../../core/errors/result.dart';
import '../entities/onboarding_data.dart';

abstract class OnboardingRepository {
  Future<Result<OnboardingData?>> getOnboardingData(String uid);
  Future<Result<void>> saveOnboardingData(String uid, OnboardingData data);
  Future<Result<String>> uploadProfilePhoto(String uid, File photoFile);
  Future<bool> isOnboardingCompletedLocally();
  Future<void> setOnboardingCompletedLocally(bool completed);
}
