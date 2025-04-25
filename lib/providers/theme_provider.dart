import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    initializeTheme();
  }

  Future<void> initializeTheme() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isDarkMode = _prefs.getBool(_themeKey) ?? true;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
