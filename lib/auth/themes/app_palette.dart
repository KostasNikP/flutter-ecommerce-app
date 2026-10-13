import 'package:flutter/material.dart';

/// Shared design tokens for the storefront.
class AppPalette {
  static const accent = Color(0xFF6657EF);
  static const mint = Color(0xFFCDFA86);
  static const ink = Color(0xFF1E2230);
  static const muted = Color(0xFF737A8B);
  static const lightBackground = Color(0xFFF7F7FA);
  static const darkBackground = Color(0xFF0D1019);
  static const darkCard = Color(0xFF1B2030);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color panel(BuildContext context) =>
      isDark(context) ? darkCard : Colors.white;

  static Color foreground(BuildContext context) =>
      isDark(context) ? const Color(0xFFF6F7FF) : ink;

  static Color subdued(BuildContext context) =>
      isDark(context) ? const Color(0xFFABB1C2) : muted;
}

ThemeData buildAppTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final foreground = dark ? const Color(0xFFF6F7FF) : AppPalette.ink;
  final background =
      dark ? AppPalette.darkBackground : AppPalette.lightBackground;
  final panel = dark ? AppPalette.darkCard : Colors.white;
  final scheme = ColorScheme.fromSeed(
    seedColor: AppPalette.accent,
    brightness: brightness,
  ).copyWith(
    primary: AppPalette.accent,
    onPrimary: Colors.white,
    surface: background,
    onSurface: foreground,
    secondary: panel,
    onSecondary: foreground,
    tertiary: panel,
    inversePrimary: foreground,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppPalette.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: panel,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
