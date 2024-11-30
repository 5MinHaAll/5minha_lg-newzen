import 'dart:core';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newzen/features/byproduct/byproduct_manager.dart';
import '../../data/generate_data.dart';
import '../../features/device/device_operation.dart';
import '../../features/device/demo_fab_manager.dart';
import '../functions/functions.dart';

class DeviceOn extends StatefulWidget {
  const DeviceOn({Key? key}) : super(key: key);

  @override
  _DeviceOnState createState() => _DeviceOnState();
}

class _DeviceOnState extends State<DeviceOn> {
  bool _isExpanded = false;
  DeviceOperation deviceOperation = DeviceOperation();
  String? _activeMode;
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
      _activeMode = null;
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
          appBar: AppBar(
            title: Text(
              "음식물 처리기",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoSegmentedControl(
                  children: _segments,
                  groupValue: _selectedIndex,
                  onValueChanged: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  selectedColor: theme.colorScheme.primary,
                  unselectedColor: theme.colorScheme.surface,
                  borderColor: theme.colorScheme.primary,
                  pressedColor: theme.colorScheme.primary.withOpacity(0.1),
                ),
              ),
              Expanded(
                child: _selectedIndex == 0
                    ? _buildMainContent()
                    : const Functions(),
              ),
            ],
          ),
          backgroundColor: theme.colorScheme.surface,
        ),

        // FAB
        _demoFabManager.buildFabLayout(
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
    Color PottingSoilColor = PottingSoilIsNormal ? Colors.green : Colors.red;

    // 교반통 상태 계산
    // bool mixingTankIsNormal = _mixingTankData?['status'] ?? "알 수 없음";
    bool mixingTankIsNormal = mixingTankNotifier.value?['status'] ?? "알 수 없음";

    String mixingTankStatus = mixingTankIsNormal ? "정상" : "비정상";
    Color mixingTankColor = mixingTankIsNormal ? Colors.green : Colors.red;

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
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.recycling,
                        size: 50, color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "음식물 처리기",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 작동 상태, 발효중 경과 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 작동 상태 카드
              ValueListenableBuilder<int>(
                valueListenable: deviceOperation.elapsedTime,
                builder: (context, elapsedTime, child) {
                  return _buildStatusCard(
                    "작동 상태",
                    deviceOperation.isOperating ? "ON" : "OFF",
                    deviceOperation.isOperating ? Colors.green : Colors.red,
                    showStopButton: deviceOperation.isOperating,
                    deviceOperation: deviceOperation,
                  );
                },
              ),

              // 발효중 경과 시간 카드
              ValueListenableBuilder<int>(
                valueListenable: deviceOperation.elapsedTime,
                builder: (context, elapsedTime, child) {
                  return _buildStatusCard(
                    "발효중 경과 시간",
                    deviceOperation.getElapsedTime(),
                    Colors.orange,
                    showStopButton: deviceOperation.isOperating,
                  );
                },
              ),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     _buildStatusCard(
          //       "작동 상태",
          //       deviceOperation.isOperating ? "ON" : "OFF", // 상태에 따라 텍스트 변경
          //       deviceOperation.isOperating
          //           ? Colors.green
          //           : Colors.red, // 상태에 따른 색상 변경
          //       showStopButton: deviceOperation.isOperating, // 정지 버튼을 보여줄지 결정
          //       deviceOperation: deviceOperation, // DeviceOperation 객체 전달
          //     ),
          //     _buildStatusCard(
          //       "발효중 경과 시간",
          //       deviceOperation.getElapsedTime(),
          //       Colors.orange,
          //       showStopButton: deviceOperation.isOperating,
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20),

          // 모든 운영 제어 버튼 (토글 형태)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildToggleButton("일반", Icons.energy_savings_leaf, Colors.teal),
              _buildToggleButton("세척", Icons.waves, Colors.orange),
              _buildToggleButton("절전", Icons.cleaning_services, Colors.red),
              _buildToggleButton("외출", Icons.biotech, Colors.pinkAccent),
            ],
          ),
          const SizedBox(height: 20),

          // 부산물통 용량 상태
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                const Text(
                  "부산물 수거함 용량",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Progress bar
                SizedBox(
                  height: 15, // Progress bar 두께 설정
                  child: LinearProgressIndicator(
                    value: byproductManager.byproductCapacity /
                        100, // Progress 비율 (0.0 ~ 1.0)
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      byproductManager.getBarColor(
                          byproductManager.byproductCapacity), // 색상 결정
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 현재 용량 및 제어 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 현재 용량 퍼센트 표시
                    Text(
                      "${byproductManager.byproductCapacity.toInt()}%", // 정수로 변환하여 퍼센트 표시
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),

                    // 증가/감소 버튼
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              byproductManager.decreaseCapacity(); // 용량 감소
                            });
                          },
                          icon: const Icon(Icons.remove, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              byproductManager
                                  .increaseCapacity(context); // 용량 증가
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoBox(
                "배양토",
                PottingSoilStatus,
                PottingSoilColor,
                (BuildContext context) =>
                    _togglePottingSoilBottomSheet(context),
                // () => _showPottingSoilModal(context),
              ),
              _buildInfoBox(
                "교반통",
                mixingTankStatus,
                mixingTankColor,
                (BuildContext context) => _toggleAgitatorBottomSheet(context),
                // () => _showAgitatorModal(context),
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
                  fontSize: 18,
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

  // 모든 운영 제어 버튼 - 토글 버튼 빌더
  Widget _buildToggleButton(String label, IconData icon, Color color) {
    final bool isActive = _activeMode == label; // 현재 모드와 비교하여 활성화 여부 결정
    return GestureDetector(
      onTap: () {
        setState(() {
          // 현재 상태가 활성화 상태면 null로 비활성화, 그렇지 않으면 활성화
          _activeMode = isActive ? null : label;
        });
      },
      child: Container(
        width: 70,
        height: 100,
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? color : Colors.grey, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: isActive ? color : Colors.grey),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive ? color : Colors.grey,
              ),
            ),
          ],
        ),
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
            onTap: () => onTap(scaffoldContext), // onTap에 context 전달
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
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
          );
        },
      ),
    );
  }

  //배양토 상태 Bottom Sheet
  void _togglePottingSoilBottomSheet(BuildContext context) {
    if (_pottingSoilBottomSheetController != null) {
      // Bottom Sheet 닫기
      _pottingSoilBottomSheetController?.close();
      _pottingSoilBottomSheetController = null;
    } else {
      // Bottom Sheet 열기
      _pottingSoilBottomSheetController = Scaffold.of(context).showBottomSheet(
        (context) => Container(
          height: MediaQuery.of(context).size.height * 0.3, // 모달 높이 설정
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ValueListenableBuilder<Map<String, dynamic>?>(
            valueListenable: pottingSoilNotifier,
            builder: (context, data, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 제목과 닫기 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "배양토",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.05, // 제목 크기
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _pottingSoilBottomSheetController?.close();
                          _pottingSoilBottomSheetController = null;
                        },
                        icon: Icon(
                          Icons.close,
                          size: MediaQuery.of(context).size.width *
                              0.06, // 아이콘 크기
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // 상태 정보
                  Column(
                    children: [
                      _buildModalRow(
                        "온도",
                        "${data?['temperature'] ?? '알 수 없음'}°C",
                        Icons.mood,
                        data?['temperatureStatus'],
                        data?['temperatureStatus'] == "보통"
                            ? Colors.green
                            : data?['temperatureStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        MediaQuery.of(context).size.width,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      _buildModalRow(
                        "습도",
                        "${data?['humidity'] ?? '알 수 없음'}%",
                        Icons.warning,
                        data?['humidityStatus'],
                        data?['humidityStatus'] == "보통"
                            ? Colors.green
                            : data?['humidityStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        MediaQuery.of(context).size.width,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      _buildModalRow(
                        "pH",
                        "${data?['ph'] ?? '알 수 없음'}",
                        Icons.mood_bad,
                        data?['phStatus'],
                        data?['phStatus'] == "보통"
                            ? Colors.green
                            : data?['phStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
  }

  //교반통 상태 Bottom Sheet
  void _toggleAgitatorBottomSheet(BuildContext context) {
    if (_agitatorBottomSheetController != null) {
      // Bottom Sheet 닫기
      _agitatorBottomSheetController?.close();
      _agitatorBottomSheetController = null;
    } else {
      // Bottom Sheet 열기
      _agitatorBottomSheetController = Scaffold.of(context).showBottomSheet(
        (context) => Container(
          height: MediaQuery.of(context).size.height * 0.4, // 모달 높이 설정
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ValueListenableBuilder<Map<String, dynamic>?>(
            valueListenable:
                mixingTankNotifier, // mixing_tank 상태를 반영하는 Notifier
            builder: (context, data, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 제목과 닫기 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "교반통",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.05, // 제목 크기
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _agitatorBottomSheetController?.close();
                          _agitatorBottomSheetController = null;
                        },
                        icon: Icon(
                          Icons.close,
                          size: MediaQuery.of(context).size.width *
                              0.06, // 아이콘 크기
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // 상태 정보
                  Column(
                    children: [
                      _buildModalRow(
                        "온도",
                        "${data?['temperature'] ?? '알 수 없음'}°C",
                        Icons.mood,
                        data?['temperatureStatus'],
                        data?['temperatureStatus'] == "보통"
                            ? Colors.green
                            : data?['temperatureStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 16),
                      _buildModalRow(
                        "습도",
                        "${data?['humidity'] ?? '알 수 없음'}%",
                        Icons.warning,
                        data?['humidityStatus'],
                        data?['humidityStatus'] == "보통"
                            ? Colors.green
                            : data?['humidityStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 16),
                      _buildModalRow(
                        "높이",
                        "${data?['volume'] ?? '알 수 없음'}",
                        Icons.mood_bad,
                        data?['volumeStatus'],
                        data?['volumeStatus'] == "보통"
                            ? Colors.green
                            : data?['volumeStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 증가 및 감소 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          mixing_tank.decreaseVolume(10.0); // 10 감소
                          final updatedData =
                              mixing_tank.generateMixingTankData(
                            isOperating: deviceOperation.isOperating,
                            deviceOperation: deviceOperation,
                            context: context,
                          );
                          mixingTankNotifier.value = updatedData; // 데이터 갱신
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("감소"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          mixing_tank.increaseVolume(10.0); // 10 증가
                          final updatedData =
                              mixing_tank.generateMixingTankData(
                            isOperating: deviceOperation.isOperating,
                            deviceOperation: deviceOperation,
                            context: context,
                          );
                          mixingTankNotifier.value = updatedData; // 데이터 갱신
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("증가"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
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
