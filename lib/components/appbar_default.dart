import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useGoogleFonts;
  final FontWeight? fontWeight;
  final List<Widget>? actions;
  final double? titleSpacing; // 추가: 타이틀 spacing 조절

  const DefaultAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.textColor,
    this.useGoogleFonts = false,
    this.fontWeight,
    this.actions,
    this.titleSpacing = 0, // 기본값 NavigationToolbar.kMiddleSpacing (16.0)
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextStyle? getTitleStyle() {
      final baseStyle = theme.textTheme.titleLarge?.copyWith(
        color: textColor ?? Colors.black,
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
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              color: textColor ?? Colors.black,
            )
          : null,
      actions: actions,
      iconTheme: IconThemeData(
        color: textColor ?? Colors.black,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
