import 'package:flutter/material.dart';
import 'package:shop_app/auth/themes/dark_mode.dart';
import 'package:shop_app/auth/themes/light_mode.dart';

/// Always begin a new app session in dark mode.
/// The user can switch to light mode temporarily from Profile.
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => identical(_themeData, darkMode);

  set themeData(ThemeData nextTheme) {
    if (identical(_themeData, nextTheme)) return;
    _themeData = nextTheme;
    notifyListeners();
  }

  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
  }
}
