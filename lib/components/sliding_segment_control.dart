import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SlidingSegmentControl extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int?> onValueChanged;

  const SlidingSegmentControl({
    super.key,
    required this.selectedIndex,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 32.0; // 세그먼트 컨트롤의 높이를 줄임

    return Container(
      height: 56,
      color: AppColors.secondaryBackground,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: CupertinoSlidingSegmentedControl<int>(
          groupValue: selectedIndex,
          onValueChanged: onValueChanged,
          backgroundColor: const Color(0xFFF5F6F8),
          thumbColor: const Color(0xFF405474),
          padding: const EdgeInsets.all(2), // 내부 패딩 줄임
          children: {
            0: _buildSegmentItem('제품', selectedIndex == 0),
            1: _buildSegmentItem('유용한 기능', selectedIndex == 1),
          },
        ),
      ),
    );
  }

  Widget _buildSegmentItem(String text, bool isSelected) {
    return Container(
      width: double.infinity,
      height: 28, // 높이 줄임
      padding: const EdgeInsets.symmetric(horizontal: 12), // 좌우 패딩 추가
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14), // height의 절반
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF7C8595),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
