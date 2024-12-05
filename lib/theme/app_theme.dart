import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: AppColors.secondaryBackground,
    dialogTheme: DialogTheme(
      titleTextStyle: AppTypography.titleMedium,
      contentTextStyle: AppTypography.bodyLarge,
    ),
    cardTheme: _cardTheme,
    listTileTheme: _listTileTheme,
  );

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    tertiary: AppColors.tertiary,
    onTertiary: Colors.white,
    surface: AppColors.primaryBackground,
    onSurface: AppColors.primaryText,
    onSurfaceVariant: AppColors.secondaryText,
    error: AppColors.error,
    onError: Colors.white,
    surfaceTint: Colors.transparent,
  );

  static final CardTheme _cardTheme = CardTheme(
    color: AppColors.primaryBackground,
    elevation: 0,
  );

  static final ListTileThemeData _listTileTheme = ListTileThemeData(
    tileColor: AppColors.primaryBackground,
  );
}
