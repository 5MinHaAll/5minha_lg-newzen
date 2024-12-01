import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Lg'; // LG ThinQ 폰트 패밀리

  // 폰트 가중치 상수
  static const FontWeight light = FontWeight.w300; // Light
  static const FontWeight regular = FontWeight.w400; // Regular
  static const FontWeight semibold = FontWeight.w600; // SemiBold
  static const FontWeight bold = FontWeight.w700; // Bold

  // Display Styles (큰 헤더)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: light,
    fontSize: 58,
    color: AppColors.primaryText,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: 46,
    color: AppColors.primaryText,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: 38,
    color: AppColors.primaryText,
  );

  // Headline Styles (중간 헤더)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: semibold,
    fontSize: 32,
    color: AppColors.primaryText,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: 28,
    color: AppColors.secondaryText,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: 24,
    color: AppColors.secondaryText,
  );

  // Title Styles (제목용)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: semibold,
    fontSize: 22,
    color: AppColors.primaryText,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: semibold,
    fontSize: 18,
    color: AppColors.primaryText,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: semibold,
    fontSize: 16,
    color: AppColors.secondaryText,
  );

  // Label Styles (라벨 및 버튼)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: semibold,
    fontSize: 14,
    color: AppColors.primary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: semibold,
    fontSize: 12,
    color: AppColors.primary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: semibold,
    fontSize: 11,
    color: AppColors.primary,
  );

  // Body Styles (본문 텍스트)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: 16,
    color: AppColors.primaryText,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: 14,
    color: AppColors.secondaryText,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: 12,
    color: AppColors.secondaryText,
  );

  // TextTheme 생성
  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );
}
