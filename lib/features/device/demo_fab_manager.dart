// features/device/demo_fab_manager.dart

import 'package:flutter/material.dart';
import '../../components/custom_alert.dart';

class DemoFabManager extends ChangeNotifier {
  late Size _screenSize;
  late double _safeAreaTop;
  late double _safeAreaBottom;

  Offset _fabPosition = const Offset(300, 600);
  bool _isExpanded = false;
  bool _isDragging = false;

  // Getters
  Offset get fabPosition => _fabPosition;
  bool get isExpanded => _isExpanded;
  bool get isDragging => _isDragging;

  void initializeFabPosition(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _safeAreaTop = MediaQuery.of(context).padding.top;
    _safeAreaBottom = MediaQuery.of(context).padding.bottom;

    _fabPosition = Offset(
      _screenSize.width - 72,
      _screenSize.height - 100,
    );
  }

  Widget buildFabLayout(
    BuildContext context, {
    required Function(double) onVolumeIncrease,
    required ThemeData theme,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            if (_isExpanded) ...[
              Positioned(
                left: _fabPosition.dx,
                top: _fabPosition.dy - 60,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = false;
                      onVolumeIncrease(50.0);
                    });
                  },
                  backgroundColor: theme.colorScheme.secondary,
                  child: const Icon(Icons.food_bank),
                ),
              ),
              Positioned(
                left: _fabPosition.dx,
                top: _fabPosition.dy - 120,
                child: FloatingActionButton(
                  onPressed: () {
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
                  },
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.block),
                ),
              ),
              Positioned(
                left: _fabPosition.dx,
                top: _fabPosition.dy - 180,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = false;
                      onVolumeIncrease(22.0);
                    });
                  },
                  backgroundColor: theme.colorScheme.secondary,
                  child: const Icon(Icons.restaurant_menu),
                ),
              ),
            ],
            Positioned(
              left: _fabPosition.dx,
              top: _fabPosition.dy,
              child: GestureDetector(
                onPanStart: (_) {
                  setState(() {
                    _isDragging = true;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    final newPosition = _fabPosition + details.delta;

                    // X축 제한
                    double constrainedX = newPosition.dx
                        .clamp(0, _screenSize.width - (_isDragging ? 60 : 56));

                    // Y축 제한
                    double constrainedY = newPosition.dy.clamp(
                        _safeAreaTop + kToolbarHeight,
                        _screenSize.height -
                            (_isDragging ? 60 : 56) -
                            _safeAreaBottom);

                    _fabPosition = Offset(constrainedX, constrainedY);
                  });
                },
                onPanEnd: (_) {
                  setState(() {
                    _isDragging = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: _isDragging ? 60 : 56,
                  height: _isDragging ? 60 : 56,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
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
            ),
          ],
        );
      },
    );
  }
}
