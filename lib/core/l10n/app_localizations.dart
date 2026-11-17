import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Roomie'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In tr, this message translates to:
  /// **'Senaryolarla Gerçek Yaşam Uyumu'**
  String get appTagline;

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İdeal oda arkadaşını bulmak için giriş yap'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginButton;

  /// No description provided for @orContinueWith.
  ///
  /// In tr, this message translates to:
  /// **'Veya şununla devam et'**
  String get orContinueWith;

  /// No description provided for @googleSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Giriş Yap'**
  String get googleSignIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın yok mu?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get signUp;

  /// No description provided for @registerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Oluştur'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Birlikte huzurla yaşayacağın kişiyi keşfet'**
  String get registerSubtitle;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Tekrar'**
  String get confirmPasswordLabel;

  /// No description provided for @registerButton.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabın var mı?'**
  String get alreadyHaveAccount;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In tr, this message translates to:
  /// **'E-postanı Doğrula'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Eşleşmeleri görmeden önce e-posta adresini doğrulaman gerekiyor. Lütfen gelen kutunu kontrol et.'**
  String get verifyEmailSubtitle;

  /// No description provided for @resendVerificationEmail.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama E-postasını Tekrar Gönder'**
  String get resendVerificationEmail;

  /// No description provided for @checkVerificationStatus.
  ///
  /// In tr, this message translates to:
  /// **'Doğruladım, Devam Et'**
  String get checkVerificationStatus;

  /// No description provided for @signOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get signOut;

  /// No description provided for @onboardingStep1Title.
  ///
  /// In tr, this message translates to:
  /// **'Temel Profil'**
  String get onboardingStep1Title;

  /// No description provided for @onboardingStep1Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Seni biraz tanıyalım'**
  String get onboardingStep1Subtitle;

  /// No description provided for @displayNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Adın Soyadın'**
  String get displayNameLabel;

  /// No description provided for @birthYearLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doğum Yılın'**
  String get birthYearLabel;

  /// No description provided for @genderLabel.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyet'**
  String get genderLabel;

  /// No description provided for @genderFemale.
  ///
  /// In tr, this message translates to:
  /// **'Kadın'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get genderMale;

  /// No description provided for @genderNonBinary.
  ///
  /// In tr, this message translates to:
  /// **'Non-binary'**
  String get genderNonBinary;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In tr, this message translates to:
  /// **'Belirtmek İstemiyorum'**
  String get genderPreferNotToSay;

  /// No description provided for @bioLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kısa Biyografi (Kendini 1-2 cümleyle anlat)'**
  String get bioLabel;

  /// No description provided for @uploadPhoto.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf Ekle'**
  String get uploadPhoto;

  /// No description provided for @onboardingStep2Title.
  ///
  /// In tr, this message translates to:
  /// **'Konut & Bütçe'**
  String get onboardingStep2Title;

  /// No description provided for @onboardingStep2Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Arama hedefini ve bütçeni belirle'**
  String get onboardingStep2Subtitle;

  /// No description provided for @intentLooking.
  ///
  /// In tr, this message translates to:
  /// **'Oda Arıyorum'**
  String get intentLooking;

  /// No description provided for @intentHaveRoom.
  ///
  /// In tr, this message translates to:
  /// **'Evim Var, Ev Arkadaşı Arıyorum'**
  String get intentHaveRoom;

  /// No description provided for @intentTeamUp.
  ///
  /// In tr, this message translates to:
  /// **'Birlikte Eve Çıkacak Birini Arıyorum'**
  String get intentTeamUp;

  /// No description provided for @cityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şehir'**
  String get cityLabel;

  /// No description provided for @districtLabel.
  ///
  /// In tr, this message translates to:
  /// **'İlçe / Semt'**
  String get districtLabel;

  /// No description provided for @budgetMinLabel.
  ///
  /// In tr, this message translates to:
  /// **'En Düşük Bütçe (₺)'**
  String get budgetMinLabel;

  /// No description provided for @budgetMaxLabel.
  ///
  /// In tr, this message translates to:
  /// **'En Yüksek Bütçe (₺)'**
  String get budgetMaxLabel;

  /// No description provided for @moveInDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Taşınma Tarihi'**
  String get moveInDateLabel;

  /// No description provided for @leaseMonthsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Düşünülen Süre (Ay)'**
  String get leaseMonthsLabel;

  /// No description provided for @onboardingStep3Title.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı Çizgiler'**
  String get onboardingStep3Title;

  /// No description provided for @onboardingStep3Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Olmazsa olmaz kurallarını seç'**
  String get onboardingStep3Subtitle;

  /// No description provided for @smokingAllowed.
  ///
  /// In tr, this message translates to:
  /// **'Sigara İçilebilir'**
  String get smokingAllowed;

  /// No description provided for @smokingForbidden.
  ///
  /// In tr, this message translates to:
  /// **'Sigara İçilmeyen Ev'**
  String get smokingForbidden;

  /// No description provided for @petsAllowed.
  ///
  /// In tr, this message translates to:
  /// **'Evcil Hayvan Dostu'**
  String get petsAllowed;

  /// No description provided for @petsForbidden.
  ///
  /// In tr, this message translates to:
  /// **'Evcil Hayvansız Ev'**
  String get petsForbidden;

  /// No description provided for @genderPreferenceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ev Arkadaşı Cinsiyet Tercihi'**
  String get genderPreferenceLabel;

  /// No description provided for @maxAgeGapLabel.
  ///
  /// In tr, this message translates to:
  /// **'Maksimum Yaş Farkı'**
  String get maxAgeGapLabel;

  /// No description provided for @continueButton.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueButton;

  /// No description provided for @backButton.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get backButton;

  /// No description provided for @saveButton.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get saveButton;

  /// No description provided for @completeOnboardingButton.
  ///
  /// In tr, this message translates to:
  /// **'Senaryo Testine Başla'**
  String get completeOnboardingButton;

  /// No description provided for @discoverTitle.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet'**
  String get discoverTitle;

  /// No description provided for @matchesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Eşleşmeler'**
  String get matchesTitle;

  /// No description provided for @chatTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sohbet'**
  String get chatTitle;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @scenarioTestTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yaşam Tarzı Testi'**
  String get scenarioTestTitle;

  /// No description provided for @scenarioSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ev arkadaşlığında gerçek senaryolara nasıl yaklaşırsın?'**
  String get scenarioSubtitle;

  /// No description provided for @scenarioProgress.
  ///
  /// In tr, this message translates to:
  /// **'Senaryo {current} / {total}'**
  String scenarioProgress(Object current, Object total);

  /// No description provided for @quickTestNotice.
  ///
  /// In tr, this message translates to:
  /// **'Eşleşmeleri açmak için en az 15 senaryoyu tamamla'**
  String get quickTestNotice;

  /// No description provided for @quickTestUnlocked.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! Eşleşmeler açıldı. Daha isabetli uyum için devam edebilirsin.'**
  String get quickTestUnlocked;

  /// No description provided for @importanceQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Bir ev arkadaşında bu konu senin için ne kadar önemli?'**
  String get importanceQuestion;

  /// No description provided for @importanceNotMuch.
  ///
  /// In tr, this message translates to:
  /// **'Fark Etmez / Önemsiz'**
  String get importanceNotMuch;

  /// No description provided for @importanceImportant.
  ///
  /// In tr, this message translates to:
  /// **'Önemli'**
  String get importanceImportant;

  /// No description provided for @importanceDealbreaker.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı Çizgi (Dealbreaker)'**
  String get importanceDealbreaker;

  /// No description provided for @finishTestEarly.
  ///
  /// In tr, this message translates to:
  /// **'Testi Şimdi Tamamla'**
  String get finishTestEarly;

  /// No description provided for @continueScenarios.
  ///
  /// In tr, this message translates to:
  /// **'Daha Fazla Senaryo Yanıtla'**
  String get continueScenarios;

  /// No description provided for @resultTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yaşam Tarzı Profilin'**
  String get resultTitle;

  /// No description provided for @resultSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Senaryo yanıtlarına göre ev içi karakterin belirlendi'**
  String get resultSubtitle;

  /// No description provided for @archetypeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ev İçi Arketipin'**
  String get archetypeLabel;

  /// No description provided for @strengthsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ev Arkadaşı Olarak Güçlü Yönlerin'**
  String get strengthsTitle;

  /// No description provided for @cautionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dikkat Edilmesi Gereken Sürtüşme Noktaları'**
  String get cautionsTitle;

  /// No description provided for @viewMatchesButton.
  ///
  /// In tr, this message translates to:
  /// **'Eşleşmeleri Keşfet'**
  String get viewMatchesButton;

  /// No description provided for @retakeTestButton.
  ///
  /// In tr, this message translates to:
  /// **'Testi Yeniden Çöz'**
  String get retakeTestButton;

  /// No description provided for @dimCleanliness.
  ///
  /// In tr, this message translates to:
  /// **'Temizlik'**
  String get dimCleanliness;

  /// No description provided for @dimNoiseTolerance.
  ///
  /// In tr, this message translates to:
  /// **'Gürültü Toleransı'**
  String get dimNoiseTolerance;

  /// No description provided for @dimSleepSchedule.
  ///
  /// In tr, this message translates to:
  /// **'Uyku Düzeni'**
  String get dimSleepSchedule;

  /// No description provided for @dimSocialEnergy.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Enerji'**
  String get dimSocialEnergy;

  /// No description provided for @dimGuestPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Misafir Politikası'**
  String get dimGuestPolicy;

  /// No description provided for @dimChoreFairness.
  ///
  /// In tr, this message translates to:
  /// **'İş Bölümü'**
  String get dimChoreFairness;

  /// No description provided for @dimMoneyStyle.
  ///
  /// In tr, this message translates to:
  /// **'Maddi Paylaşım'**
  String get dimMoneyStyle;

  /// No description provided for @dimConflictStyle.
  ///
  /// In tr, this message translates to:
  /// **'İletişim & Çatışma'**
  String get dimConflictStyle;

  /// No description provided for @dimPrivacyNeed.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel Alan'**
  String get dimPrivacyNeed;

  /// No description provided for @dimResponsibility.
  ///
  /// In tr, this message translates to:
  /// **'Sorumluluk Bilinci'**
  String get dimResponsibility;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
