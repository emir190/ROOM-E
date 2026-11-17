import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('tr')) {
    _loadSavedLocale();
  }

  static const String _kLocaleKey = 'app_selected_locale';

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_kLocaleKey);
      if (savedCode != null && (savedCode == 'tr' || savedCode == 'en')) {
        state = Locale(savedCode);
      }
    } catch (_) {}
  }

  Future<void> setLocale(Locale newLocale) async {
    state = newLocale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLocaleKey, newLocale.languageCode);
    } catch (_) {}
  }

  void toggleLocale() {
    if (state.languageCode == 'tr') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('tr'));
    }
  }
}
