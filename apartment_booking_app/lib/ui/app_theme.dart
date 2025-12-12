import 'package:flutter/material.dart';

class AppColors {
  // Teal/Cream color palette (from your Figma design)
  static const Color primary = Color(0xFF346B7A); // Dark teal
  static const Color primaryLight = Color(0xFF5FB1C4); // Light teal
  static const Color primaryDark = Color(0xFF2A5A66); // Darker teal
  static const Color background = Color(0xFFF5F0E6); // Cream
  static const Color cardBackground = Color(0xFFF0E1D9); // Light beige
  static const Color cardLight = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF1E1B18);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color border = Color(0xFFE0D5C7);
  static const Color success = Color(0xFF4CAF50);
  static const Color rating = Color(0xFFFFB400);
  
  // Legacy colors for backward compatibility
  static const Color darkTeal = primary;
  static const Color lightTeal = primaryLight;
  static const Color cream = background;
  static const Color card = cardLight;
  static const Color textDark = textPrimary;
}

ThemeData baytiTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.primaryLight,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    foregroundColor: AppColors.textPrimary,
    surfaceTintColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      elevation: 0,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardLight,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.border, width: 1),
    ),
  ),
);
