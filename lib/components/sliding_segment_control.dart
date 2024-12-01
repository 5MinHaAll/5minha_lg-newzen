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
      height: 56,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: selectedIndex,
        onValueChanged: onValueChanged,
        backgroundColor: const Color(0xFFF5F6F8),
        thumbColor: const Color(0xFF405474),
        padding: const EdgeInsets.all(4),
        children: {
          0: _buildSegmentItem('제품', selectedIndex == 0),
          1: _buildSegmentItem('유용한 기능', selectedIndex == 1),
        },
      ),
    );
  }

  Widget _buildSegmentItem(String text, bool isSelected) {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
