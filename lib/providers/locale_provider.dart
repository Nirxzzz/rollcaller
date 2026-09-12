import 'package:flutter/material.dart' show ChangeNotifier, Locale;
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/strings.dart';

/// Holds the app-wide language preference.
///
/// A `null` locale means "follow the device language": Chinese devices get
/// Chinese, while every other device language falls back to English. This is
/// resolved by MaterialApp.localeResolutionCallback when [locale] is null.
class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  /// The forced locale, or null when following the device language.
  Locale? get locale => _locale;

  /// Persisted preference code: 'system', 'zh' or 'en'.
  String get languageCode {
    return switch (_locale?.languageCode) {
      'zh' => 'zh',
      'en' => 'en',
      _ => 'system',
    };
  }

  /// Restore a previously loaded value without rebuilding listeners.
  /// Used once during startup before MaterialApp is built.
  void setLocaleWithoutNotify(Locale? locale) {
    _locale = locale;
  }

  /// Change the language preference, notify listeners and persist it.
  Future<void> setLanguage(String code) async {
    _locale = switch (code) {
      'zh' => const Locale('zh'),
      'en' => const Locale('en'),
      _ => null,
    };
    notifyListeners();

    final storage = await SharedPreferences.getInstance();
    await storage.setString(KString.languagePreferenceKey, code);
  }
}
