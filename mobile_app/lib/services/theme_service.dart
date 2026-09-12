import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The user's chosen app theme (system/light/dark), persisted locally and
/// shared everywhere via `provider` (see main.dart).
class ThemePreference extends ChangeNotifier {
  static const _prefsKey = 'preferred_theme_mode';

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    _mode = ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }

  /// Flips between light and dark, ignoring "system" — used by the quick
  /// toggle button on the home screen.
  Future<void> toggle(BuildContext context) async {
    final currentlyDark = _mode == ThemeMode.dark ||
        (_mode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    await setMode(currentlyDark ? ThemeMode.light : ThemeMode.dark);
  }
}
