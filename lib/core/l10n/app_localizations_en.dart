// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Roomie';

  @override
  String get appTagline => 'Real Living Compatibility Through Scenarios';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginSubtitle => 'Sign in to find your compatible roommate';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginButton => 'Sign In';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Discover who you can live peacefully with';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get registerButton => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get verifyEmailTitle => 'Verify Your Email';

  @override
  String get verifyEmailSubtitle =>
      'You need to verify your email address before viewing matches. Please check your inbox.';

  @override
  String get resendVerificationEmail => 'Resend Verification Email';

  @override
  String get checkVerificationStatus => 'I\'ve Verified, Continue';

  @override
  String get signOut => 'Sign Out';

  @override
  String get onboardingStep1Title => 'Basic Profile';

  @override
  String get onboardingStep1Subtitle => 'Let\'s get to know you';

  @override
  String get displayNameLabel => 'Full Name';

  @override
  String get birthYearLabel => 'Birth Year';

  @override
  String get genderLabel => 'Gender';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderMale => 'Male';

  @override
  String get genderNonBinary => 'Non-binary';

  @override
  String get genderPreferNotToSay => 'Prefer not to say';

  @override
  String get bioLabel => 'Short Bio (Tell about yourself in 1-2 sentences)';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get onboardingStep2Title => 'Housing & Budget';

  @override
  String get onboardingStep2Subtitle => 'Define your housing goal and budget';

  @override
  String get intentLooking => 'Looking for a Room';

  @override
  String get intentHaveRoom => 'Have a Place, Need a Roommate';

  @override
  String get intentTeamUp => 'Looking to Team Up for an Apartment';

  @override
  String get cityLabel => 'City';

  @override
  String get districtLabel => 'District / Neighborhood';

  @override
  String get budgetMinLabel => 'Minimum Budget (₺)';

  @override
  String get budgetMaxLabel => 'Maximum Budget (₺)';

  @override
  String get moveInDateLabel => 'Move-in Date';

  @override
  String get leaseMonthsLabel => 'Intended Lease (Months)';

  @override
  String get onboardingStep3Title => 'Dealbreakers';

  @override
  String get onboardingStep3Subtitle =>
      'Select your non-negotiable living rules';

  @override
  String get smokingAllowed => 'Smoking Allowed';

  @override
  String get smokingForbidden => 'Non-smoking Home';

  @override
  String get petsAllowed => 'Pet-friendly';

  @override
  String get petsForbidden => 'Pet-free Home';

  @override
  String get genderPreferenceLabel => 'Roommate Gender Preference';

  @override
  String get maxAgeGapLabel => 'Maximum Age Gap';

  @override
  String get continueButton => 'Continue';

  @override
  String get backButton => 'Back';

  @override
  String get saveButton => 'Save';

  @override
  String get completeOnboardingButton => 'Start Scenario Test';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get matchesTitle => 'Matches';

  @override
  String get chatTitle => 'Chat';

  @override
  String get profileTitle => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get scenarioTestTitle => 'Living Style Test';

  @override
  String get scenarioSubtitle =>
      'How do you handle realistic roommate situations?';

  @override
  String scenarioProgress(Object current, Object total) {
    return 'Scenario $current / $total';
  }

  @override
  String get quickTestNotice =>
      'Complete at least 15 scenarios to unlock matches';

  @override
  String get quickTestUnlocked =>
      'Congratulations! Matching unlocked. Continue answering to improve accuracy.';

  @override
  String get importanceQuestion =>
      'How important is this to you in a roommate?';

  @override
  String get importanceNotMuch => 'Not Much';

  @override
  String get importanceImportant => 'Important';

  @override
  String get importanceDealbreaker => 'Dealbreaker';

  @override
  String get finishTestEarly => 'Finish Test Now';

  @override
  String get continueScenarios => 'Answer More Scenarios';

  @override
  String get resultTitle => 'Your Living Style Profile';

  @override
  String get resultSubtitle =>
      'Your domestic archetype has been computed based on your answers';

  @override
  String get archetypeLabel => 'Your Living Archetype';

  @override
  String get strengthsTitle => 'Your Strengths as a Roommate';

  @override
  String get cautionsTitle => 'Potential Friction Points';

  @override
  String get viewMatchesButton => 'Discover Matches';

  @override
  String get retakeTestButton => 'Retake Test';

  @override
  String get dimCleanliness => 'Cleanliness';

  @override
  String get dimNoiseTolerance => 'Noise Tolerance';

  @override
  String get dimSleepSchedule => 'Sleep Schedule';

  @override
  String get dimSocialEnergy => 'Social Energy';

  @override
  String get dimGuestPolicy => 'Guest Policy';

  @override
  String get dimChoreFairness => 'Chore Fairness';

  @override
  String get dimMoneyStyle => 'Money Style';

  @override
  String get dimConflictStyle => 'Conflict Style';

  @override
  String get dimPrivacyNeed => 'Privacy Need';

  @override
  String get dimResponsibility => 'Responsibility';
}
