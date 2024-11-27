import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      surface: AppColors.primaryBackground,
      onSurface: AppColors.primaryText,
      surfaceContainerHighest: AppColors.primaryBackground,
      onSurfaceVariant: AppColors.secondaryText,
      error: AppColors.error,
      onError: Colors.white,
      surfaceTint: Colors.transparent,
    ),
    textTheme: AppTypography.getTextTheme(),
    scaffoldBackgroundColor: AppColors.secondaryBackground,
    cardTheme: const CardTheme(
      color: AppColors.primaryBackground,
      elevation: 0,
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: AppColors.primaryBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}