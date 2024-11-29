import 'package:flutter/material.dart';
import '../../components/custom_alert.dart';

class DemoFabManager {
  Offset _fabPosition = const Offset(300, 600);
  bool _isExpanded = false;
  bool _isDragging = false;

  Offset get fabPosition => _fabPosition;
  bool get isExpanded => _isExpanded;
  bool get isDragging => _isDragging;

  void updateFabPosition(Offset delta) {
    _fabPosition += delta;
  }

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
  }

  void setDragging(bool dragging) {
    _isDragging = dragging;
  }

  void initializeFabPosition(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _fabPosition = Offset(
      screenSize.width - 72,
      screenSize.height - 100,
    );
  }

  Widget buildFabLayout(
    BuildContext context, {
    required Function(double) onVolumeIncrease,
    required Function() onToggleExpanded,
    required ThemeData theme,
  }) {
    return Stack(
      children: [
        if (_isExpanded) ...[
          _buildExpandedFabButton(
            context,
            position: _fabPosition.translate(0, -60),
            onPressed: () {
              _isExpanded = false;
              onVolumeIncrease(50.0);
            },
            icon: Icons.food_bank,
            color: theme.colorScheme.secondary,
          ),
          _buildExpandedFabButton(
            context,
            position: _fabPosition.translate(0, -120),
            onPressed: () {
              _showWarningDialog(context);
            },
            icon: Icons.block,
            color: Colors.grey,
          ),
          _buildExpandedFabButton(
            context,
            position: _fabPosition.translate(0, -180),
            onPressed: () {
              _isExpanded = false;
              onVolumeIncrease(22.0);
            },
            icon: Icons.restaurant_menu,
            color: theme.colorScheme.secondary,
          ),
        ],
        _buildMainFab(context, onToggleExpanded, theme),
      ],
    );
  }

  Widget _buildExpandedFabButton(
    BuildContext context, {
    required Offset position,
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: color,
        child: Icon(icon),
      ),
    );
  }

  Widget _buildMainFab(
    BuildContext context,
    VoidCallback onToggleExpanded,
    ThemeData theme,
  ) {
    return Positioned(
      left: _fabPosition.dx,
      top: _fabPosition.dy,
      child: GestureDetector(
        onPanStart: (_) => setDragging(true),
        onPanUpdate: (details) => updateFabPosition(details.delta),
        onPanEnd: (_) => setDragging(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: _isDragging ? 60 : 56,
          height: _isDragging ? 60 : 56,
          child: FloatingActionButton(
            onPressed: onToggleExpanded,
            backgroundColor: _isExpanded
                ? theme.colorScheme.error
                : theme.colorScheme.secondary,
            child: Icon(
              _isExpanded ? Icons.close : Icons.menu,
              color: theme.colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlert(
          title: "경고",
          content: "이 음식물은 처리할 수 없습니다.",
          onConfirm: () {
            print("경고창 닫힘");
          },
        );
      },
    );
  }
}
