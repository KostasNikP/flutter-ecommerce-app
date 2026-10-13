import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/auth/themes/dark_mode.dart';
import 'package:shop_app/auth/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider({SharedPreferences? preferences})
      : _preferences = preferences {
    _themeData = preferences?.getBool(_storageKey) == true
        ? darkMode
        : lightMode;
  }

  static const _storageKey = 'nova.darkMode.v1';
  final SharedPreferences? _preferences;
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    final preferences = _preferences;
    if (preferences != null) {
      unawaited(preferences.setBool(_storageKey, isDarkMode));
    }
    notifyListeners();
  }

  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
  }
}
