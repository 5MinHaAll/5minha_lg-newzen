// sliding_segment_control.dart
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
    return Container(
      height: kBottomNavigationBarHeight,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: selectedIndex,
        onValueChanged: onValueChanged,
        backgroundColor: AppColors.secondaryBackground,
        thumbColor: const Color(0xFF405474),
        padding: const EdgeInsets.all(4),
        children: {
          0: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '제품',
              style: TextStyle(
                color:
                    selectedIndex == 0 ? Colors.white : const Color(0XFF606C80),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          1: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '유용한 기능',
              style: TextStyle(
                color:
                    selectedIndex == 1 ? Colors.white : const Color(0XFF606C80),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        },
      ),
    );
  }
}
