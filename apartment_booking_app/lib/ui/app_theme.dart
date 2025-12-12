import 'package:flutter/material.dart';

class AppColors {
  // From Figma-ish palette
  static const Color darkTeal = Color(0xFF0F5663);
  static const Color lightTeal = Color(0xFF5FB1C4);
  static const Color cream = Color(0xFFF5F0E6);
  static const Color card = Color(0xFFF0E1D9);
  static const Color textDark = Color(0xFF1E1B18);
}

ThemeData baytiTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.cream,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.darkTeal,
    primary: AppColors.darkTeal,
    secondary: AppColors.lightTeal,
    background: AppColors.cream,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: AppColors.textDark,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.darkTeal,
      textStyle: const TextStyle(
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkTeal,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
);
