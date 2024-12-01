import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import '../theme/app_colors.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final Color? textColor;
  final FontWeight? fontWeight;

  const CustomAlert({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.textColor,
    this.fontWeight,
  }) : super(key: key);

  @override
  // TODO: DialogTheme 적용 여부 확인
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ThemeData theme = ThemeData(
      dialogTheme: DialogTheme(
          titleTextStyle: AppTypography.titleMedium.copyWith(
            color: textColor ?? AppColors.primaryText,
            fontWeight: AppTypography.bold,
          ),
          contentTextStyle: AppTypography.bodyLarge.copyWith(
            color: textColor ?? AppColors.primaryText,
            fontWeight: AppTypography.semibold,
          )),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(title),
            const SizedBox(height: 8),
            // Content
            Text(
              content,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            // Confirm Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "확인",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.success,
                        fontWeight: AppTypography.semibold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
