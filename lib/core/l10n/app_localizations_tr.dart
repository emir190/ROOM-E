// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Roomie';

  @override
  String get appTagline => 'Senaryolarla Gerçek Yaşam Uyumu';

  @override
  String get loginTitle => 'Giriş Yap';

  @override
  String get loginSubtitle => 'İdeal oda arkadaşını bulmak için giriş yap';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get forgotPassword => 'Şifremi Unuttum?';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get orContinueWith => 'Veya şununla devam et';

  @override
  String get googleSignIn => 'Google ile Giriş Yap';

  @override
  String get dontHaveAccount => 'Hesabın yok mu?';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get registerTitle => 'Hesap Oluştur';

  @override
  String get registerSubtitle => 'Birlikte huzurla yaşayacağın kişiyi keşfet';

  @override
  String get confirmPasswordLabel => 'Şifre Tekrar';

  @override
  String get registerButton => 'Kayıt Ol';

  @override
  String get alreadyHaveAccount => 'Zaten hesabın var mı?';

  @override
  String get verifyEmailTitle => 'E-postanı Doğrula';

  @override
  String get verifyEmailSubtitle =>
      'Eşleşmeleri görmeden önce e-posta adresini doğrulaman gerekiyor. Lütfen gelen kutunu kontrol et.';

  @override
  String get resendVerificationEmail => 'Doğrulama E-postasını Tekrar Gönder';

  @override
  String get checkVerificationStatus => 'Doğruladım, Devam Et';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get onboardingStep1Title => 'Temel Profil';

  @override
  String get onboardingStep1Subtitle => 'Seni biraz tanıyalım';

  @override
  String get displayNameLabel => 'Adın Soyadın';

  @override
  String get birthYearLabel => 'Doğum Yılın';

  @override
  String get genderLabel => 'Cinsiyet';

  @override
  String get genderFemale => 'Kadın';

  @override
  String get genderMale => 'Erkek';

  @override
  String get genderNonBinary => 'Non-binary';

  @override
  String get genderPreferNotToSay => 'Belirtmek İstemiyorum';

  @override
  String get bioLabel => 'Kısa Biyografi (Kendini 1-2 cümleyle anlat)';

  @override
  String get uploadPhoto => 'Fotoğraf Ekle';

  @override
  String get onboardingStep2Title => 'Konut & Bütçe';

  @override
  String get onboardingStep2Subtitle => 'Arama hedefini ve bütçeni belirle';

  @override
  String get intentLooking => 'Oda Arıyorum';

  @override
  String get intentHaveRoom => 'Evim Var, Ev Arkadaşı Arıyorum';

  @override
  String get intentTeamUp => 'Birlikte Eve Çıkacak Birini Arıyorum';

  @override
  String get cityLabel => 'Şehir';

  @override
  String get districtLabel => 'İlçe / Semt';

  @override
  String get budgetMinLabel => 'En Düşük Bütçe (₺)';

  @override
  String get budgetMaxLabel => 'En Yüksek Bütçe (₺)';

  @override
  String get moveInDateLabel => 'Taşınma Tarihi';

  @override
  String get leaseMonthsLabel => 'Düşünülen Süre (Ay)';

  @override
  String get onboardingStep3Title => 'Kırmızı Çizgiler';

  @override
  String get onboardingStep3Subtitle => 'Olmazsa olmaz kurallarını seç';

  @override
  String get smokingAllowed => 'Sigara İçilebilir';

  @override
  String get smokingForbidden => 'Sigara İçilmeyen Ev';

  @override
  String get petsAllowed => 'Evcil Hayvan Dostu';

  @override
  String get petsForbidden => 'Evcil Hayvansız Ev';

  @override
  String get genderPreferenceLabel => 'Ev Arkadaşı Cinsiyet Tercihi';

  @override
  String get maxAgeGapLabel => 'Maksimum Yaş Farkı';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get backButton => 'Geri';

  @override
  String get saveButton => 'Kaydet';

  @override
  String get completeOnboardingButton => 'Senaryo Testine Başla';

  @override
  String get discoverTitle => 'Keşfet';

  @override
  String get matchesTitle => 'Eşleşmeler';

  @override
  String get chatTitle => 'Sohbet';

  @override
  String get profileTitle => 'Profil';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get scenarioTestTitle => 'Yaşam Tarzı Testi';

  @override
  String get scenarioSubtitle =>
      'Ev arkadaşlığında gerçek senaryolara nasıl yaklaşırsın?';

  @override
  String scenarioProgress(Object current, Object total) {
    return 'Senaryo $current / $total';
  }

  @override
  String get quickTestNotice =>
      'Eşleşmeleri açmak için en az 15 senaryoyu tamamla';

  @override
  String get quickTestUnlocked =>
      'Tebrikler! Eşleşmeler açıldı. Daha isabetli uyum için devam edebilirsin.';

  @override
  String get importanceQuestion =>
      'Bir ev arkadaşında bu konu senin için ne kadar önemli?';

  @override
  String get importanceNotMuch => 'Fark Etmez / Önemsiz';

  @override
  String get importanceImportant => 'Önemli';

  @override
  String get importanceDealbreaker => 'Kırmızı Çizgi (Dealbreaker)';

  @override
  String get finishTestEarly => 'Testi Şimdi Tamamla';

  @override
  String get continueScenarios => 'Daha Fazla Senaryo Yanıtla';

  @override
  String get resultTitle => 'Yaşam Tarzı Profilin';

  @override
  String get resultSubtitle =>
      'Senaryo yanıtlarına göre ev içi karakterin belirlendi';

  @override
  String get archetypeLabel => 'Ev İçi Arketipin';

  @override
  String get strengthsTitle => 'Ev Arkadaşı Olarak Güçlü Yönlerin';

  @override
  String get cautionsTitle => 'Dikkat Edilmesi Gereken Sürtüşme Noktaları';

  @override
  String get viewMatchesButton => 'Eşleşmeleri Keşfet';

  @override
  String get retakeTestButton => 'Testi Yeniden Çöz';

  @override
  String get dimCleanliness => 'Temizlik';

  @override
  String get dimNoiseTolerance => 'Gürültü Toleransı';

  @override
  String get dimSleepSchedule => 'Uyku Düzeni';

  @override
  String get dimSocialEnergy => 'Sosyal Enerji';

  @override
  String get dimGuestPolicy => 'Misafir Politikası';

  @override
  String get dimChoreFairness => 'İş Bölümü';

  @override
  String get dimMoneyStyle => 'Maddi Paylaşım';

  @override
  String get dimConflictStyle => 'İletişim & Çatışma';

  @override
  String get dimPrivacyNeed => 'Kişisel Alan';

  @override
  String get dimResponsibility => 'Sorumluluk Bilinci';
}
