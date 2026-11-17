import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roomie/core/constants/turkey_locations.dart';
import 'package:roomie/core/errors/result.dart';
import 'package:roomie/core/widgets/turkish_char_bar.dart';
import 'package:roomie/features/onboarding/application/onboarding_controller.dart';
import 'package:roomie/features/onboarding/domain/entities/onboarding_data.dart';
import 'package:roomie/features/onboarding/domain/repositories/onboarding_repository.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late MockOnboardingRepository mockOnboardingRepository;
  late OnboardingController onboardingController;

  setUpAll(() {
    registerFallbackValue(OnboardingData());
  });

  setUp(() {
    mockOnboardingRepository = MockOnboardingRepository();
    when(() => mockOnboardingRepository.getOnboardingData(any()))
        .thenAnswer((_) async => const Success(null));
    when(() => mockOnboardingRepository.saveOnboardingData(any(), any()))
        .thenAnswer((_) async => const Success(null));
    when(() => mockOnboardingRepository.setOnboardingCompletedLocally(any()))
        .thenAnswer((_) async {});

    onboardingController = OnboardingController(mockOnboardingRepository, 'user123');
  });

  tearDown(() {
    onboardingController.dispose();
  });

  group('OnboardingController Tests', () {
    test('initial step is 0', () {
      expect(onboardingController.state.currentStep, 0);
      expect(onboardingController.state.isCompleted, isFalse);
    });

    test('updateBasicProfile updates displayName, birthYear and gender', () {
      onboardingController.updateBasicProfile(
        displayName: 'Ahmet Yılmaz',
        birthYear: 2000,
        gender: Gender.male,
        bio: 'Mühendislik öğrencisi',
      );

      expect(onboardingController.state.data.displayName, 'Ahmet Yılmaz');
      expect(onboardingController.state.data.birthYear, 2000);
      expect(onboardingController.state.data.gender, Gender.male);
      expect(onboardingController.state.data.bio, 'Mühendislik öğrencisi');
    });

    test('nextStep and previousStep work within bounds (0..2)', () {
      expect(onboardingController.state.currentStep, 0);
      onboardingController.nextStep();
      expect(onboardingController.state.currentStep, 1);
      onboardingController.nextStep();
      expect(onboardingController.state.currentStep, 2);
      onboardingController.nextStep();
      expect(onboardingController.state.currentStep, 2); // clamped at 2

      onboardingController.previousStep();
      expect(onboardingController.state.currentStep, 1);
      onboardingController.previousStep();
      expect(onboardingController.state.currentStep, 0);
      onboardingController.previousStep();
      expect(onboardingController.state.currentStep, 0); // clamped at 0
    });

    test('completeOnboarding marks state as completed and saves to repository', () async {
      final success = await onboardingController.completeOnboarding();

      expect(success, isTrue);
      expect(onboardingController.state.isCompleted, isTrue);
      verify(() => mockOnboardingRepository.saveOnboardingData(
            'user123',
            any(that: isA<OnboardingData>()),
          )).called(1);
      verify(() => mockOnboardingRepository.setOnboardingCompletedLocally(true)).called(1);
    });

    test('setPhotoUrl updates photoUrls with selected photo at the front', () {
      onboardingController.setPhotoUrl('https://example.com/avatar1.jpg');
      expect(onboardingController.state.data.photoUrls.first, 'https://example.com/avatar1.jpg');

      onboardingController.setPhotoUrl('https://example.com/avatar2.jpg');
      expect(onboardingController.state.data.photoUrls.first, 'https://example.com/avatar2.jpg');
      expect(onboardingController.state.data.photoUrls.length, 2);
    });

    test('Özellik 1: TurkeyLocations returns alphabetically sorted cities and districts', () {
      final cities = TurkeyLocations.sortedCities;
      expect(cities.length, 81);
      expect(cities.first, 'Adana');
      expect(cities.last, 'Zonguldak');

      final istanbulDistricts = TurkeyLocations.getDistrictsForCity('İstanbul');
      expect(istanbulDistricts, isNotEmpty);
      expect(istanbulDistricts.first, 'Adalar');
      expect(istanbulDistricts.last, 'Zeytinburnu');
    });

    test('Özellik 2: haveRoom intent calculates perPersonRent from totalHouseRent and householdPersonCount', () {
      onboardingController.updateHousingIntent(
        intent: HousingIntent.haveRoom,
        city: 'İstanbul',
        district: 'Kadıköy',
        budgetMin: 8000,
        budgetMax: 18000,
        totalHouseRent: 30000,
        householdPersonCount: 3,
        moveInDate: DateTime(2026, 12, 1),
        leaseMonths: 12,
      );

      final data = onboardingController.state.data;
      expect(data.intent, HousingIntent.haveRoom);
      expect(data.totalHouseRent, 30000);
      expect(data.householdPersonCount, 3);
      expect(data.perPersonRent, 10000);
      expect(data.budgetMin, 10000);
      expect(data.budgetMax, 10000);
    });

    test('TurkishTextUtils supports Turkish character insertion and search normalization', () {
      final controller = TextEditingController(text: 'Bura');
      controller.selection = const TextSelection.collapsed(offset: 2);
      TurkishTextUtils.insertChar(controller, 'ğ');
      expect(controller.text, 'Buğra');

      expect(TurkishTextUtils.toLowerTurkish('İSTANBUL'), 'istanbul');
      expect(TurkishTextUtils.toLowerTurkish('IĞDIR'), 'ığdır');
      expect(
        TurkishTextUtils.normalizeForSearch('Kadıköy'),
        TurkishTextUtils.normalizeForSearch('kadikoy'),
      );
      controller.dispose();
    });
  });
}
