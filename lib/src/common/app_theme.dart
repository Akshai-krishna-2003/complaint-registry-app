import 'package:flutter/material.dart';

class AppTheme {
  // ----- Brand colours -----
  static const Color primary = Color(0xFF1A3A5C);      // Deep navy blue
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFD5E4F5);
  static const Color onPrimaryContainer = Color(0xFF0C1F33);

  static const Color secondary = Color(0xFFD49A3E);    // Warm gold accent
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFFFEED9);

  static const Color surface = Color(0xFFF8F9FC);       // Light greyish background
  static const Color onSurface = Color(0xFF191C20);
  static const Color error = Color(0xFFB00020);

  // ----- Status colours -----
  static const Color statusPending = Color(0xFFE67E22);    // Orange
  static const Color statusUnderReview = Color(0xFF2980B9); // Blue
  static const Color statusResolved = Color(0xFF27AE60);    // Green
  static const Color statusRejected = Color(0xFFC0392B);    // Red

  // ----- Light Theme -----
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      surface: surface,
      onSurface: onSurface,
      error: error,
    ),
    scaffoldBackgroundColor: surface,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: primary,
      foregroundColor: onPrimary,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onPrimary,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: onSurface, letterSpacing: -0.5),
      headlineSmall: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: onSurface),
      bodyLarge: TextStyle(fontSize: 16, color: onSurface, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: onSurface, height: 1.4),
      labelLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD9DCDE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD9DCDE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF5F6B7A)),
      hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
    ),
  );
}