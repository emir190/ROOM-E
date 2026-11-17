import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../auth/application/auth_controller.dart';
import '../data/repositories/onboarding_repository_impl.dart';
import '../domain/entities/onboarding_data.dart';
import '../domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl();
});

class OnboardingState {
  final int currentStep;
  final OnboardingData data;
  final bool isLoading;
  final bool isUploadingPhoto;
  final Failure? failure;
  final bool isCompleted;

  const OnboardingState({
    this.currentStep = 0,
    required this.data,
    this.isLoading = false,
    this.isUploadingPhoto = false,
    this.failure,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    OnboardingData? data,
    bool? isLoading,
    bool? isUploadingPhoto,
    Failure? failure,
    bool? isCompleted,
    bool clearFailure = false,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      failure: clearFailure ? null : (failure ?? this.failure),
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  final authUser = ref.watch(authControllerProvider).user;
  return OnboardingController(repository, authUser?.uid);
});

class OnboardingController extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;
  final String? _uid;

  OnboardingController(this._repository, this._uid)
      : super(OnboardingState(data: OnboardingData())) {
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    if (_uid == null) return;
    state = state.copyWith(isLoading: true);
    final Result<OnboardingData?> result = await _repository.getOnboardingData(_uid);
    result.fold<void>(
      onSuccess: (OnboardingData? data) {
        if (data != null) {
          final isDone = data.onboardingStep == 'scenarios' || data.onboardingStep == 'completed';
          state = state.copyWith(
            data: data,
            isLoading: false,
            isCompleted: isDone,
          );
        } else {
          state = state.copyWith(isLoading: false);
        }
      },
      onError: (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  void updateBasicProfile({
    required String displayName,
    required int birthYear,
    required Gender gender,
    required String bio,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(
        displayName: displayName,
        birthYear: birthYear,
        gender: gender,
        bio: bio,
        onboardingStep: 'profile',
      ),
    );
  }

  Future<bool> uploadPhoto(File file) async {
    if (_uid == null) {
      final updatedPhotos = <String>[file.path, ...state.data.photoUrls];
      state = state.copyWith(
        isUploadingPhoto: false,
        data: state.data.copyWith(photoUrls: updatedPhotos),
      );
      return true;
    }
    state = state.copyWith(isUploadingPhoto: true, clearFailure: true);
    final result = await _repository.uploadProfilePhoto(_uid, file);
    return result.fold(
      onSuccess: (url) {
        final updatedPhotos = <String>[
          url,
          ...state.data.photoUrls.where((p) => p != url),
        ];
        state = state.copyWith(
          isUploadingPhoto: false,
          data: state.data.copyWith(photoUrls: updatedPhotos),
        );
        return true;
      },
      onError: (_) {
        // Fallback so user's selected local photo is still set
        final updatedPhotos = <String>[file.path, ...state.data.photoUrls];
        state = state.copyWith(
          isUploadingPhoto: false,
          data: state.data.copyWith(photoUrls: updatedPhotos),
        );
        return true;
      },
    );
  }

  void setPhotoUrl(String url) {
    final updatedPhotos = <String>[
      url,
      ...state.data.photoUrls.where((p) => p != url),
    ];
    state = state.copyWith(
      data: state.data.copyWith(photoUrls: updatedPhotos),
    );
  }

  void updateHousingIntent({
    required HousingIntent intent,
    required String city,
    required String district,
    required double budgetMin,
    required double budgetMax,
    double? totalHouseRent,
    int? householdPersonCount,
    required DateTime moveInDate,
    required int leaseMonths,
  }) {
    final rentTotal = totalHouseRent ?? state.data.totalHouseRent;
    final personCount = householdPersonCount ?? state.data.householdPersonCount;
    final perPerson = personCount > 0 ? rentTotal / personCount : rentTotal;

    state = state.copyWith(
      data: state.data.copyWith(
        intent: intent,
        city: city,
        district: district,
        budgetMin: intent == HousingIntent.haveRoom ? perPerson : budgetMin,
        budgetMax: intent == HousingIntent.haveRoom ? perPerson : budgetMax,
        totalHouseRent: rentTotal,
        householdPersonCount: personCount,
        moveInDate: moveInDate,
        leaseMonths: leaseMonths,
        onboardingStep: 'intent',
      ),
    );
  }

  void updateHardFilters({
    required List<Gender> genderPreference,
    required bool smokingDealbreaker,
    required bool petsDealbreaker,
    required int maxAgeGap,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(
        filters: HardFilters(
          genderPreference: genderPreference,
          smokingDealbreaker: smokingDealbreaker,
          petsDealbreaker: petsDealbreaker,
          maxAgeGap: maxAgeGap,
        ),
        onboardingStep: 'filters',
      ),
    );
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
      _persistCurrentState();
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> _persistCurrentState() async {
    if (_uid == null) return;
    await _repository.saveOnboardingData(_uid, state.data);
  }

  Future<bool> completeOnboarding() async {
    if (_uid == null) return false;
    state = state.copyWith(isLoading: true, clearFailure: true);

    final finalData = state.data.copyWith(onboardingStep: 'scenarios');
    final result = await _repository.saveOnboardingData(_uid, finalData);

    return result.fold(
      onSuccess: (_) async {
        await _repository.setOnboardingCompletedLocally(true);
        state = state.copyWith(
          isLoading: false,
          data: finalData,
          isCompleted: true,
        );
        return true;
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
    );
  }
}
