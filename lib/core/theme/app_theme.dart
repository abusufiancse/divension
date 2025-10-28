import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.cardLight,
      background: AppColors.bgLight,
    ),
    scaffoldBackgroundColor: AppColors.bgLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimaryLight,
      centerTitle: true,
      elevation: 0,
    ),
    cardColor: AppColors.cardLight,
    useMaterial3: true,
    // 添加Nunito字体
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Nunito'),
      displayMedium: TextStyle(fontFamily: 'Nunito'),
      displaySmall: TextStyle(fontFamily: 'Nunito'),
      headlineLarge: TextStyle(fontFamily: 'Nunito'),
      headlineMedium: TextStyle(fontFamily: 'Nunito'),
      headlineSmall: TextStyle(fontFamily: 'Nunito'),
      titleLarge: TextStyle(fontFamily: 'Nunito'),
      titleMedium: TextStyle(fontFamily: 'Nunito'),
      titleSmall: TextStyle(fontFamily: 'Nunito'),
      bodyLarge: TextStyle(fontFamily: 'Nunito'),
      bodyMedium: TextStyle(fontFamily: 'Nunito'),
      bodySmall: TextStyle(fontFamily: 'Nunito'),
      labelLarge: TextStyle(fontFamily: 'Nunito'),
      labelMedium: TextStyle(fontFamily: 'Nunito'),
      labelSmall: TextStyle(fontFamily: 'Nunito'),
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.cardDark,
      background: AppColors.bgDark,
    ),
    scaffoldBackgroundColor: AppColors.bgDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimaryDark,
      centerTitle: true,
      elevation: 0,
    ),
    cardColor: AppColors.cardDark,
    useMaterial3: true,
    // 添加Nunito字体
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Nunito'),
      displayMedium: TextStyle(fontFamily: 'Nunito'),
      displaySmall: TextStyle(fontFamily: 'Nunito'),
      headlineLarge: TextStyle(fontFamily: 'Nunito'),
      headlineMedium: TextStyle(fontFamily: 'Nunito'),
      headlineSmall: TextStyle(fontFamily: 'Nunito'),
      titleLarge: TextStyle(fontFamily: 'Nunito'),
      titleMedium: TextStyle(fontFamily: 'Nunito'),
      titleSmall: TextStyle(fontFamily: 'Nunito'),
      bodyLarge: TextStyle(fontFamily: 'Nunito'),
      bodyMedium: TextStyle(fontFamily: 'Nunito'),
      bodySmall: TextStyle(fontFamily: 'Nunito'),
      labelLarge: TextStyle(fontFamily: 'Nunito'),
      labelMedium: TextStyle(fontFamily: 'Nunito'),
      labelSmall: TextStyle(fontFamily: 'Nunito'),
    ),
  );
}