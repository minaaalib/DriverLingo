import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

/// The user's chosen reviewer/exam language (English/Filipino/Hiligaynon),
/// picked once on the welcome screen and reused everywhere else (exam
/// setup, exam questions, results) so it's never asked for twice.
/// Registered as a [ChangeNotifier] with `provider` in main.dart.
class LanguagePreference extends ChangeNotifier {
  static const _prefsKey = 'preferred_language';

  String _language = AppLanguage.english;
  bool _isLoaded = false;

  String get language => _language;
  bool get isLoaded => _isLoaded;

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored != null && AppLanguage.labels.containsKey(stored)) {
      _language = stored;
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (language == _language) return;
    _language = language;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, language);
  }
}
