enum HousingIntent {
  needRoom,
  haveRoom,
  teamUp,
}

enum Gender {
  female,
  male,
  nonBinary,
  preferNotToSay,
}

class HardFilters {
  final List<Gender> genderPreference;
  final bool smokingDealbreaker;
  final bool petsDealbreaker;
  final int maxAgeGap;

  const HardFilters({
    this.genderPreference = const [Gender.female, Gender.male, Gender.nonBinary],
    this.smokingDealbreaker = false,
    this.petsDealbreaker = false,
    this.maxAgeGap = 10,
  });

  HardFilters copyWith({
    List<Gender>? genderPreference,
    bool? smokingDealbreaker,
    bool? petsDealbreaker,
    int? maxAgeGap,
  }) {
    return HardFilters(
      genderPreference: genderPreference ?? this.genderPreference,
      smokingDealbreaker: smokingDealbreaker ?? this.smokingDealbreaker,
      petsDealbreaker: petsDealbreaker ?? this.petsDealbreaker,
      maxAgeGap: maxAgeGap ?? this.maxAgeGap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'genderPreference': genderPreference.map((g) => g.name).toList(),
      'smokingDealbreaker': smokingDealbreaker,
      'petsDealbreaker': petsDealbreaker,
      'maxAgeGap': maxAgeGap,
    };
  }

  factory HardFilters.fromMap(Map<String, dynamic> map) {
    return HardFilters(
      genderPreference: (map['genderPreference'] as List<dynamic>?)
              ?.map((e) => Gender.values.firstWhere(
                    (g) => g.name == e,
                    orElse: () => Gender.female,
                  ))
              .toList() ??
          const [Gender.female, Gender.male],
      smokingDealbreaker: map['smokingDealbreaker'] as bool? ?? false,
      petsDealbreaker: map['petsDealbreaker'] as bool? ?? false,
      maxAgeGap: (map['maxAgeGap'] as num?)?.toInt() ?? 10,
    );
  }
}

class OnboardingData {
  // Step 1: Basic Profile
  final String displayName;
  final int birthYear;
  final Gender gender;
  final String bio;
  final List<String> photoUrls;

  // Step 2: Housing & Budget
  final HousingIntent intent;
  final String city;
  final String district;
  final double budgetMin;
  final double budgetMax;
  final double totalHouseRent;
  final int householdPersonCount;
  final DateTime moveInDate;
  final int leaseMonths;

  double get perPersonRent =>
      householdPersonCount > 0 ? totalHouseRent / householdPersonCount : totalHouseRent;

  // Step 3: Hard Filters
  final HardFilters filters;

  // Status
  final String onboardingStep; // 'profile', 'intent', 'filters', 'scenarios', 'completed'

  OnboardingData({
    this.displayName = '',
    this.birthYear = 2002,
    this.gender = Gender.preferNotToSay,
    this.bio = '',
    this.photoUrls = const [],
    this.intent = HousingIntent.needRoom,
    this.city = 'İstanbul',
    this.district = 'Kadıköy',
    this.budgetMin = 8000,
    this.budgetMax = 18000,
    this.totalHouseRent = 24000,
    this.householdPersonCount = 2,
    DateTime? moveInDate,
    this.leaseMonths = 12,
    this.filters = const HardFilters(),
    this.onboardingStep = 'profile',
  }) : moveInDate = moveInDate ?? DateTime.now().add(const Duration(days: 30));

  OnboardingData copyWith({
    String? displayName,
    int? birthYear,
    Gender? gender,
    String? bio,
    List<String>? photoUrls,
    HousingIntent? intent,
    String? city,
    String? district,
    double? budgetMin,
    double? budgetMax,
    double? totalHouseRent,
    int? householdPersonCount,
    DateTime? moveInDate,
    int? leaseMonths,
    HardFilters? filters,
    String? onboardingStep,
  }) {
    return OnboardingData(
      displayName: displayName ?? this.displayName,
      birthYear: birthYear ?? this.birthYear,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      photoUrls: photoUrls ?? this.photoUrls,
      intent: intent ?? this.intent,
      city: city ?? this.city,
      district: district ?? this.district,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      totalHouseRent: totalHouseRent ?? this.totalHouseRent,
      householdPersonCount: householdPersonCount ?? this.householdPersonCount,
      moveInDate: moveInDate ?? this.moveInDate,
      leaseMonths: leaseMonths ?? this.leaseMonths,
      filters: filters ?? this.filters,
      onboardingStep: onboardingStep ?? this.onboardingStep,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'displayName': displayName,
      'birthYear': birthYear,
      'gender': gender.name,
      'bio': bio,
      'photoUrls': photoUrls,
      'intent': intent.name,
      'city': city,
      'district': district,
      'budgetMin': budgetMin,
      'budgetMax': budgetMax,
      'totalHouseRent': totalHouseRent,
      'householdPersonCount': householdPersonCount,
      'perPersonRent': perPersonRent,
      'moveInDate': moveInDate,
      'leaseMonths': leaseMonths,
      'filters': filters.toMap(),
      'onboardingStep': onboardingStep,
    };
  }

  factory OnboardingData.fromFirestore(Map<String, dynamic> data) {
    return OnboardingData(
      displayName: data['displayName'] as String? ?? '',
      birthYear: (data['birthYear'] as num?)?.toInt() ?? 2002,
      gender: Gender.values.firstWhere(
        (g) => g.name == data['gender'],
        orElse: () => Gender.preferNotToSay,
      ),
      bio: data['bio'] as String? ?? '',
      photoUrls: (data['photoUrls'] as List<dynamic>?)?.cast<String>() ?? const [],
      intent: HousingIntent.values.firstWhere(
        (i) => i.name == data['intent'],
        orElse: () => HousingIntent.needRoom,
      ),
      city: data['city'] as String? ?? 'İstanbul',
      district: data['district'] as String? ?? 'Kadıköy',
      budgetMin: (data['budgetMin'] as num?)?.toDouble() ?? 8000,
      budgetMax: (data['budgetMax'] as num?)?.toDouble() ?? 18000,
      totalHouseRent: (data['totalHouseRent'] as num?)?.toDouble() ?? 24000,
      householdPersonCount: (data['householdPersonCount'] as num?)?.toInt() ?? 2,
      moveInDate: data['moveInDate'] != null
          ? (data['moveInDate'] is DateTime
              ? data['moveInDate'] as DateTime
              : DateTime.tryParse(data['moveInDate'].toString()) ?? DateTime.now())
          : DateTime.now(),
      leaseMonths: (data['leaseMonths'] as num?)?.toInt() ?? 12,
      filters: data['filters'] != null
          ? HardFilters.fromMap(data['filters'] as Map<String, dynamic>)
          : const HardFilters(),
      onboardingStep: data['onboardingStep'] as String? ?? 'profile',
    );
  }
}
