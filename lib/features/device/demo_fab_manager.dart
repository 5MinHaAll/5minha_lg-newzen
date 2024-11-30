import 'package:flutter/material.dart';
import '../../components/custom_alert.dart';

class FabItem {
  final String imagePath;
  final String tooltip;
  final VoidCallback onPressed;
  final Offset position;

  FabItem({
    required this.imagePath,
    required this.tooltip,
    required this.onPressed,
    required this.position,
  });
}

class DemoFabManager extends ChangeNotifier {
  late Size _screenSize;
  late double _safeAreaTop;
  late double _safeAreaBottom;

  Offset _fabPosition = const Offset(300, 600);
  bool _isExpanded = false;
  bool _isDragging = false;

  final double _fabSize = 56.0;
  final double _spacing = 100.0;

  void initializeFabPosition(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _safeAreaTop = MediaQuery.of(context).padding.top;
    _safeAreaBottom = MediaQuery.of(context).padding.bottom;

    _fabPosition = Offset(
      _screenSize.width - _fabSize - 16,
      _screenSize.height - _fabSize - _safeAreaBottom - 16,
    );
    _isExpanded = false;
  }

  Widget _buildStyledFab({
    required VoidCallback onPressed,
    required Widget child,
    required Color backgroundColor,
    required double size,
    String? tooltip,
    bool isExpanded = false,
  }) {
    Widget fab = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            isExpanded ? Border.all(color: Colors.grey[300]!, width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        elevation: 0,
        shape: const CircleBorder(),
        child: child,
      ),
    );

    if (tooltip != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0), // tooltip과 버튼 사이 간격 추가
        child: Tooltip(
          message: tooltip,
          preferBelow: false,
          verticalOffset: 32, // tooltip이 버튼으로부터 더 멀리 표시되도록 조정
          child: fab,
        ),
      );
    }

    return fab;
  }

  void _showSnackBar(
      BuildContext context, String type, Function(double) onVolumeIncrease) {
    double amount = type == '일반 음식물' ? 50.0 : 22.0;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type을 투입했습니다.'),
        action: SnackBarAction(
          label: '취소',
          onPressed: () {
            // 투입 취소 로직
            onVolumeIncrease(-amount); // 투입한 양만큼 감소
          },
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: _safeAreaBottom + 16,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  Widget buildFabLayout(
    BuildContext context, {
    required Function(double) onVolumeIncrease,
    required ThemeData theme,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        List<FabItem> fabItems = [
          FabItem(
            imagePath: 'assets/images/device/fab_hamburger.png',
            tooltip: '일반 음식물',
            onPressed: () {
              setState(() {
                _isExpanded = false;
                onVolumeIncrease(50.0);
                _showSnackBar(context, '일반 음식물', onVolumeIncrease);
              });
            },
            position: Offset(-_spacing * 1.2, 0),
          ),
          FabItem(
            imagePath: 'assets/images/device/fab_gum.png',
            tooltip: '투입 불가',
            onPressed: () => _showWarningDialog(context),
            position: Offset(-_spacing * 0.85, -_spacing * 0.85),
          ),
          FabItem(
            imagePath: 'assets/images/device/fab_pasta.png',
            tooltip: '소량 음식물',
            onPressed: () {
              setState(() {
                _isExpanded = false;
                onVolumeIncrease(22.0);
                _showSnackBar(context, '소량 음식물', onVolumeIncrease);
              });
            },
            position: Offset(0, -_spacing * 1.2),
          ),
        ];

        return Stack(
          children: [
            if (_isExpanded) ...[
              for (var item in fabItems)
                Positioned(
                  left: _fabPosition.dx + item.position.dx,
                  top: _fabPosition.dy + item.position.dy,
                  child: _buildStyledFab(
                    size: _fabSize,
                    onPressed: item.onPressed,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      item.imagePath,
                      width: 32,
                      height: 32,
                    ),
                    tooltip: item.tooltip,
                    isExpanded: true,
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

                    double constrainedX = newPosition.dx.clamp(
                      _spacing,
                      _screenSize.width - _fabSize,
                    );

                    double constrainedY = newPosition.dy.clamp(
                      _safeAreaTop + kToolbarHeight + _spacing,
                      _screenSize.height - _fabSize - _safeAreaBottom,
                    );

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
                  width: _isDragging ? _fabSize + 4 : _fabSize,
                  height: _isDragging ? _fabSize + 4 : _fabSize,
                  child: _buildStyledFab(
                    size: _fabSize,
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    backgroundColor:
                        _isExpanded ? theme.colorScheme.error : Colors.white,
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.menu,
                      color: _isExpanded ? Colors.white : Colors.black,
                      size: 28,
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
