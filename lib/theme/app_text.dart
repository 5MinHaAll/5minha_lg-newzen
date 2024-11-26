import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Lg'; // 공통 폰트 패밀리

  static TextTheme getTextTheme() {
    return TextTheme(
      // Display Styles
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400, // Regular
        fontSize: 57,
        color: AppColors.primaryText, // 커스텀 색상
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 45,
        color: AppColors.primaryText,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 36,
        color: AppColors.primaryText,
      ),

      // Headline Styles
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 32,
        color: AppColors.secondaryText, // 커스텀 색상
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 28,
        color: AppColors.secondaryText,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 24,
        color: AppColors.secondaryText,
      ),

      // Title Styles
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500, // Medium
        fontSize: 22,
        color: AppColors.primaryText,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.primaryText,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.secondaryText,
      ),

      // Label Styles
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.accent1, // 커스텀 색상
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColors.accent1,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        color: AppColors.accent1,
      ),

      // Body Styles
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400, // Regular
        fontSize: 16,
        color: AppColors.secondaryText,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.secondaryText,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColors.secondaryText,
      ),
    );
  }
}