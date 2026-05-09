import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary = Color(0xFF2563EB);       // Blue
  static const Color primaryVariant = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF7C3AED);     // Purple
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFDC2626);         // Red
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Color(0xFF0F172A);
  static const Color onSurface = Color(0xFF334155);
  static const Color disabled = Color(0xFF94A3B8);

  // Status / Snackbar
  static const Color success = Color(0xFF16A34A);       // Green
  static const Color warning = Color(0xFFF59E0B);       // Amber
  static const Color info = Color(0xFF0EA5E9);          // Sky
  static const Color failure = error;                   // Red (same as error)

  // White & black variants
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color infoLight = Color(0xFFE0F2FE);
  static const Color failureLight = Color(0xFFFEE2E2);
}