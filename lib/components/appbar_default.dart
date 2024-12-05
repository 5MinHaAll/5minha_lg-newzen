import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useGoogleFonts;
  final FontWeight? fontWeight;
  final List<Widget>? actions;
  final double? titleSpacing;
  final Widget? customLeading;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.textColor,
    this.useGoogleFonts = false,
    this.fontWeight = FontWeight.bold,
    this.actions,
    this.titleSpacing = 0, // 기본값 NavigationToolbar.kMiddleSpacing (16.0)
    this.customLeading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextStyle? getTitleStyle() {
      final baseStyle = AppTypography.titleLarge.copyWith(
        // color: textColor ?? AppColors.primaryText,
        fontWeight: fontWeight,
      );

      if (useGoogleFonts) {
        return GoogleFonts.roboto(textStyle: baseStyle);
      }

      return baseStyle;
    }

    return AppBar(
      title: Text(
        title,
        style: getTitleStyle(),
      ),
      backgroundColor: backgroundColor ?? AppColors.secondaryBackground,
      titleSpacing: titleSpacing, // 타이틀 spacing 설정
      // leading: Navigator.canPop(context)
      //     ? IconButton(
      //         icon: const Icon(Icons.arrow_back),
      //         onPressed: () => Navigator.of(context).pop(),
      //         color: textColor ?? AppColors.tertiaryText,
      //       )
      //     : null,
      leading: customLeading ??
          (Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  color: textColor ?? AppColors.tertiaryText,
                )
              : null),
      actions: actions,
      iconTheme: IconThemeData(
        color: textColor ?? AppColors.primaryText,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
