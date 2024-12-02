// device.dart
import 'dart:core';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newzen/features/byproduct/byproduct_manager.dart';
import 'package:newzen/theme/app_text.dart';
import '../../components/appbar_default.dart';
import '../../components/sliding_segment_control.dart';
import '../../data/generate_data.dart';
import '../../features/device/device_operation.dart';
import '../../features/device/demo_fab_manager.dart';
import '../../theme/app_colors.dart';
import '../functions/functions.dart';

class DeviceOn extends StatefulWidget {
  const DeviceOn({Key? key}) : super(key: key);

  @override
  _DeviceOnState createState() => _DeviceOnState();
}

class _DeviceOnState extends State<DeviceOn> {
  bool _isExpanded = false;
  DeviceOperation deviceOperation = DeviceOperation();
  // String? _activeMode;
  String _activeMode = "일반";
  late final ByproductManager byproductManager;
  Map<String, dynamic>? _PottingSoilData;
  Map<String, dynamic>? _mixingTankData;
  final RandomDataService potting_soil = RandomDataService();
  final RandomDataService mixing_tank = RandomDataService();
  Timer? _timer;
  int _selectedIndex = 0;
  final DemoFabManager _demoFabManager = DemoFabManager();

  ScrollController _scrollController = ScrollController();
  PersistentBottomSheetController? _bottomSheetController;
  PersistentBottomSheetController? _agitatorBottomSheetController;
  PersistentBottomSheetController? _pottingSoilBottomSheetController; // 추가 선언

  final Map<int, Widget> _segments = const {
    0: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text('제품'),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text('유용한 기능'),
    ),
  };

  @override
  void initState() {
    super.initState();
    _startPeriodicUpdates();
    byproductManager = ByproductManager(byproductCapacity: 35.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _demoFabManager.initializeFabPosition(context);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose(); // ScrollController 해제
    super.dispose();
  }

  ValueNotifier<Map<String, dynamic>?> pottingSoilNotifier =
      ValueNotifier(null);
  ValueNotifier<Map<String, dynamic>?> mixingTankNotifier = ValueNotifier(null);

  void _startPeriodicUpdates() {
    // 초기 데이터 설정
    pottingSoilNotifier.value = potting_soil.generatePottingSoilData();
    mixingTankNotifier.value = mixing_tank.generateMixingTankData(
        isOperating: deviceOperation.isOperating, context: context);

    setState(() {
      _PottingSoilData = pottingSoilNotifier.value;
      _mixingTankData = mixingTankNotifier.value;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      try {
        // 비동기 데이터 갱신
        final pottingSoilData = await potting_soil.generatePottingSoilData();
        final mixingData = await mixing_tank.generateMixingTankData(
            isOperating: deviceOperation.isOperating,
            deviceOperation: deviceOperation,
            context: context);

        // ValueNotifier로 데이터 업데이트
        setState(() {
          pottingSoilNotifier.value = pottingSoilData;
          mixingTankNotifier.value = mixingData;
        });

        // 부산물 상태 증가 처리
        if (mixingData["shouldIncreaseByproduct"] == true) {
          byproductManager.increaseCapacity(context,
              increment: mixing_tank.getAmount() * 0.1);
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    });
  }

  void _resetState() {
    setState(() {
      // 초기 상태로 재설정
      _isExpanded = false;
      _activeMode = "일반";
      _selectedIndex = 0;

      // DeviceOperation 및 데이터 초기화
      deviceOperation.resetOperation();
      potting_soil.reset(); // 배양토 데이터 초기화
      mixing_tank.reset(); // 교반통 데이터 초기화

      final initialPottingSoliData = potting_soil.generatePottingSoilData();
      final initialMixingData = mixing_tank.generateMixingTankData(
          isOperating: deviceOperation.isOperating, context: context);

      _PottingSoilData = initialPottingSoliData;
      _mixingTankData = initialMixingData;

      // FAB 위치 초기화
      _demoFabManager.initializeFabPosition(context);

      // 부산물 관리자 초기화
      byproductManager.resetByproductCapacity();

      // 타이머 재설정
      _timer?.cancel();
      _startPeriodicUpdates();

      print("화면이 초기화되었습니다.");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: DefaultAppBar(
            title: "음식물 처리기",
            backgroundColor: AppColors.secondaryBackground,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: AppColors.secondaryBackground,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: _selectedIndex == 0
                        ? _buildMainContent()
                        : const Functions(),
                  ),
                  // 하단에 SlidingSegmentControl 높이만큼 여백 추가
                  const SliverToBoxAdapter(
                    child: SizedBox(height: kBottomNavigationBarHeight),
                  ),
                ],
              ),
              // SlidingSegmentControl을 하단에 고정
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SlidingSegmentControl(
                  selectedIndex: _selectedIndex,
                  onValueChanged: (int? index) {
                    if (index != null) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          // backgroundColor: theme.colorScheme.surface,
        ),

        // FAB with animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300), // 올라오는 시간 유지
          reverseDuration: const Duration(milliseconds: 500), // 내려가는 시간 늘림
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          child: _selectedIndex == 0
              ? _demoFabManager.buildFabLayout(
                  key: const ValueKey<int>(1),
                  context,
                  onVolumeIncrease: (amount) {
                    setState(() {
                      mixing_tank.increaseVolume(amount);
                      mixing_tank.setAmount(amount);
                      mixing_tank.setDecreaseRate(amount == 50.0 ? 1 : 2);
                      _mixingTankData = mixing_tank.generateMixingTankData(
                        isOperating: deviceOperation.isOperating,
                        deviceOperation: deviceOperation,
                        context: context,
                      );
                      deviceOperation.startOperation();
                    });
                  },
                  theme: theme,
                )
              : const SizedBox.shrink(key: ValueKey<int>(2)),
        ),
      ],
    );
  }

  // 메인 콘텐츠
  Widget _buildMainContent() {
    // 배양토 상태 계산
    // bool PottingSoilIsNormal = _PottingSoilData?['status'] ?? "알 수 없음";
    bool PottingSoilIsNormal = pottingSoilNotifier.value?['status'] ?? "알 수 없음";

    String PottingSoilStatus = PottingSoilIsNormal ? "정상" : "비정상";
    Color PottingSoilColor =
        PottingSoilIsNormal ? AppColors.success : AppColors.error;

    // 교반통 상태 계산
    // bool mixingTankIsNormal = _mixingTankData?['status'] ?? "알 수 없음";
    bool mixingTankIsNormal = mixingTankNotifier.value?['status'] ?? "알 수 없음";

    String mixingTankStatus = mixingTankIsNormal ? "정상" : "비정상";
    Color mixingTankColor =
        mixingTankIsNormal ? AppColors.success : AppColors.error;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 이미지 및 제목
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _resetState(); // 아이콘 클릭 시 상태 초기화
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Image.asset(
                      'assets/images/device/newzen.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 0),

                // 작동 상태 버튼
                ValueListenableBuilder<int>(
                  valueListenable: deviceOperation.elapsedTime,
                  builder: (context, elapsedTime, child) {
                    return FilledButton(
                      onPressed: () {
                        if (deviceOperation.isOperating) {
                          deviceOperation.resetOperation(); // 작동 중지
                        } else {
                          deviceOperation.startOperation(); // 작동 시작
                        }
                        setState(() {}); // UI 갱신
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: deviceOperation.isOperating
                            ? AppColors.success
                            : const Color(0xFF959595),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "작동 상태   ",
                            style: AppTypography.labelMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            deviceOperation.isOperating ? "ON" : "OFF",
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // 발효중 경과 시간 텍스트
                const SizedBox(height: 4),
                ValueListenableBuilder<int>(
                  valueListenable: deviceOperation.elapsedTime,
                  builder: (context, elapsedTime, child) {
                    return Text(
                      "경과 시간 ${deviceOperation.getElapsedTime()}",
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primaryText,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 작동 모드 섹션
          Text(
            "작동 모드",
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // 메뉴와 버튼을 포함하는 Row
          Row(
            children: [
              // 드롭다운 메뉴
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: _activeMode, // 이미 non-nullable String으로 선언되어 있음
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(value: "일반", child: Text("일반")),
                    DropdownMenuItem(value: "외출", child: Text("외출")),
                    DropdownMenuItem(value: "절전", child: Text("절전")),
                    DropdownMenuItem(value: "세척", child: Text("세척")),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      // null 체크 추가
                      setState(() {
                        _activeMode = newValue; // null이 아닌 경우에만 할당
                      });
                    }
                  },
                ),
              ),

              const SizedBox(width: 20),

              // 버튼 그룹
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildModeIconButton(
                      mode: "외출",
                      icon: Icons.directions_walk, // 또는 Image.asset 사용
                      activeColor: Colors.orange,
                    ),
                    _buildModeIconButton(
                      mode: "절전",
                      icon: Icons.eco, // 또는 Image.asset 사용
                      activeColor: Colors.green,
                    ),
                    _buildModeIconButton(
                      mode: "세척",
                      icon: Icons.waves, // 또는 Image.asset 사용
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 부산물통 용량 상태
          Text(
            "부산물 수거함 용량",
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                SizedBox(
                  height: 15,
                  child: LinearProgressIndicator(
                    value: byproductManager.byproductCapacity / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      byproductManager
                          .getBarColor(byproductManager.byproductCapacity),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 현재 용량 및 제어 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${byproductManager.byproductCapacity.toInt()}%",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              byproductManager.decreaseCapacity();
                            });
                          },
                          icon: const Icon(Icons.remove, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              byproductManager.increaseCapacity(context);
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 배양토 상태 & 교반통 상태
          Row(
            children: [
              // mainAxisAlignment 제거
              _buildInfoBox(
                "배양토",
                PottingSoilStatus,
                PottingSoilColor,
                (BuildContext context) =>
                    _togglePottingSoilBottomSheet(context),
              ),
              _buildInfoBox(
                "교반통",
                mixingTankStatus,
                mixingTankColor,
                (BuildContext context) => _toggleAgitatorBottomSheet(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 작동 상태 카드 + 발효중 경과 시간
  Widget _buildStatusCard(
    String title,
    String value,
    Color color, {
    required bool showStopButton,
    DeviceOperation? deviceOperation,
  }) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // "작동 상태" 텍스트를 버튼처럼 동작하도록 변경
              GestureDetector(
                onTap: () {
                  if (showStopButton && deviceOperation != null) {
                    if (deviceOperation.isOperating) {
                      deviceOperation.resetOperation(); // 작동 중지
                    } else {
                      deviceOperation.startOperation(); // 작동 시작
                    }
                    setState(() {}); // UI 갱신
                  }
                },
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline, // 텍스트에 밑줄 추가 (선택 사항)
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 새로운 IconButton 빌더 메서드 추가
  Widget _buildModeIconButton({
    required String mode,
    required IconData icon,
    required Color activeColor,
  }) {
    final bool isActive = _activeMode == mode;

    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor.withOpacity(0.1) : Colors.grey[100],
        border: Border.all(
          color: isActive ? activeColor : Colors.grey,
          width: 2,
        ),
      ),
      child: IconButton(
        onPressed: () {
          setState(() {
            _activeMode = isActive ? "일반" : mode;
          });
        },
        icon: Icon(
          icon,
          color: isActive ? activeColor : Colors.grey,
          size: 16,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 16, // IconButton의 최소 너비
          minHeight: 16, // IconButton의 최소 높이
        ),
        tooltip: mode,
      ),
    );
  }

  // 배양토 상태, 교반통 상태 - 정보 박스 빌더
  Widget _buildInfoBox(
      String title, String value, Color color, Function(BuildContext) onTap) {
    return Expanded(
      child: Builder(
        builder: (BuildContext scaffoldContext) {
          return GestureDetector(
            onTap: () => onTap(scaffoldContext),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(right: 8), // 오른쪽 박스만 오른쪽 마진 적용
              decoration: BoxDecoration(
                color: color == AppColors.success
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 이미지 추가
                  Image.asset(
                    title == "배양토"
                        ? 'assets/images/device/potting_soil.png'
                        : 'assets/images/device/mixing_tank.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //배양토 상태 Bottom Sheet
  void _togglePottingSoilBottomSheet(BuildContext context) {
    if (_pottingSoilBottomSheetController != null) {
      _pottingSoilBottomSheetController?.close();
      _pottingSoilBottomSheetController = null;
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFEFF1F5),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ValueListenableBuilder<Map<String, dynamic>?>(
                  valueListenable: pottingSoilNotifier,
                  builder: (context, data, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "배양토 상태",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryText,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/device/potting_soil.png',
                                height: 48,
                                width: 48,
                              ),
                              const SizedBox(height: 16),
                              _buildStatusRow(
                                "온도",
                                "${data?['temperature'] ?? '알 수 없음'}°C",
                                data?['temperatureStatus'] ?? "",
                                data?['temperatureStatus'] == "보통"
                                    ? AppColors.success
                                    : AppColors.error,
                                context,
                              ),
                              const SizedBox(height: 16),
                              _buildStatusRow(
                                "습도",
                                "${data?['humidity'] ?? '알 수 없음'}%",
                                data?['humidityStatus'] ?? "",
                                data?['humidityStatus'] == "보통"
                                    ? AppColors.success
                                    : AppColors.error,
                                context,
                              ),
                              const SizedBox(height: 16),
                              _buildStatusRow(
                                "pH",
                                "${data?['ph'] ?? '알 수 없음'}",
                                data?['phStatus'] ?? "",
                                data?['phStatus'] == "보통"
                                    ? AppColors.success
                                    : AppColors.error,
                                context,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  //교반통 상태 Bottom Sheet
  void _toggleAgitatorBottomSheet(BuildContext context) {
    if (_agitatorBottomSheetController != null) {
      _agitatorBottomSheetController?.close();
      _agitatorBottomSheetController = null;
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFEFF1F5),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ValueListenableBuilder<Map<String, dynamic>?>(
                  valueListenable: mixingTankNotifier,
                  builder: (context, data, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "교반통 상태",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryText,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/device/mixing_tank.png',
                                height: 48,
                                width: 48,
                              ),
                              const SizedBox(height: 16),
                              _buildStatusRow(
                                "온도",
                                "${data?['temperature'] ?? '알 수 없음'}°C",
                                data?['temperatureStatus'] ?? "",
                                data?['temperatureStatus'] == "보통"
                                    ? AppColors.success
                                    : AppColors.error,
                                context,
                              ),
                              const SizedBox(height: 16),
                              _buildStatusRow(
                                "습도",
                                "${data?['humidity'] ?? '알 수 없음'}%",
                                data?['humidityStatus'] ?? "",
                                data?['humidityStatus'] == "보통"
                                    ? AppColors.success
                                    : AppColors.error,
                                context,
                              ),
                              const SizedBox(height: 16),
                              _buildStatusRow(
                                "높이",
                                "${data?['volume'] ?? '알 수 없음'}",
                                data?['volumeStatus'] ?? "",
                                data?['volumeStatus'] == "보통"
                                    ? AppColors.success
                                    : AppColors.error,
                                context,
                              ),
                              const SizedBox(height: 24),
                              // 증가 및 감소 버튼
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FilledButton(
                                    onPressed: () {
                                      mixing_tank.decreaseVolume(10.0);
                                      final updatedData =
                                          mixing_tank.generateMixingTankData(
                                        isOperating:
                                            deviceOperation.isOperating,
                                        deviceOperation: deviceOperation,
                                        context: context,
                                      );
                                      mixingTankNotifier.value = updatedData;
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.error,
                                    ),
                                    child: const Text("감소"),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      mixing_tank.increaseVolume(10.0);
                                      final updatedData =
                                          mixing_tank.generateMixingTankData(
                                        isOperating:
                                            deviceOperation.isOperating,
                                        deviceOperation: deviceOperation,
                                        context: context,
                                      );
                                      mixingTankNotifier.value = updatedData;
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                    ),
                                    child: const Text("증가"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // 상태 행을 구성하는 새로운 위젯
  Widget _buildStatusRow(String label, String value, String status,
      Color statusColor, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primaryText,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModalRow(String label, String value, IconData icon,
      String status, Color color, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04, // 동적 텍스트 크기
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: screenWidth * 0.05, // 동적 아이콘 크기
              ),
              SizedBox(width: screenWidth * 0.02), // 간격 동적 설정
              Text(
                status,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 하단 네비게이션 바
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index; // 선택된 탭 업데이트
        });
      },
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.devices),
          label: "제품",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.extension),
          label: "유용한 기능",
        ),
      ],
    );
  }
}
