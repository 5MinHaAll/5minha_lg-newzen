import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useGoogleFonts;
  final FontWeight? fontWeight;
  final List<Widget>? actions;
  final double? titleSpacing;
  final Widget? customLeading;
  final TabController tabController;
  final List<String> tabs;
  final Color? tabColor;
  final Color? unselectedTabColor;
  final Color? indicatorColor;

  const TabAppBar({
    super.key,
    required this.title,
    required this.tabController,
    required this.tabs,
    this.backgroundColor,
    this.textColor,
    this.useGoogleFonts = false,
    this.fontWeight = FontWeight.bold,
    this.actions,
    this.titleSpacing = 0,
    this.customLeading,
    this.tabColor,
    this.unselectedTabColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextStyle? getTitleStyle() {
      final baseStyle = AppTypography.getTextTheme().titleLarge?.copyWith(
            color: textColor ?? AppColors.primaryText,
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
      titleSpacing: titleSpacing,
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
        color: textColor ?? AppColors.tertiaryText,
      ),
      bottom: TabBar.secondary(
        controller: tabController,
        labelColor: AppColors.primaryText,
        unselectedLabelColor: AppColors.tertiaryText,
        indicatorColor: AppColors.primaryText,
        dividerColor: const Color(0xFFCAD0DC),
        labelStyle: AppTypography.getTextTheme().titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        unselectedLabelStyle: AppTypography.getTextTheme().titleMedium,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 48); // AppBar 높이 + TabBar 높이
}
