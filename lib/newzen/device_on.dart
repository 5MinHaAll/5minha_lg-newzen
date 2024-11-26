import 'dart:core';
import 'dart:async'; // Timer를 위해 추가

import '../data/generate_data.dart';
import 'package:flutter/material.dart';
import '../data/save_data.dart';
import 'custom_alert.dart';
import 'device_operation.dart';
import 'functions.dart'; // 유용한 기능 페이지 import

class DeviceOn extends StatefulWidget {
  const DeviceOn({Key? key}) : super(key: key);

  @override
  _DeviceOnState createState() => _DeviceOnState();
}

class _DeviceOnState extends State<DeviceOn> {
  // FAB 버튼 상태 변수
  bool _isExpanded = false;

  // DeviceOperation 객체 생성
  DeviceOperation deviceOperation = DeviceOperation();

  // 현재 활성화된 모드
  String? _activeMode;

  Map<String, dynamic>? _PottingSoilData;
  Map<String, dynamic>? _mixingTankData;
  Map<String, dynamic>? _outputTankData;

  // RandomDataService 객체
  final RandomDataService potting_soil = RandomDataService(); // 배양토
  final RandomDataService mixing_tank = RandomDataService(); // 교반통

  // 부산물
  RandomDataService output_tank = RandomDataService();

  // Timer 변수
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    print("initState 시작");
    _startPeriodicUpdates(); // 화면 시작 시 타이머 시작
  }

  @override
  void dispose() {
    _timer?.cancel(); // 화면 종료 시 타이머 중지
    super.dispose();
  }

  // 일정 시간마다 데이터를 갱신하는 타이머 설정
  void _startPeriodicUpdates() {
    final initialPottingSoliData = potting_soil.generatePottingSoilData();
    final initialMixingData = mixing_tank.generateMixingTankData(
        isOperating: deviceOperation.isOperating, context: context);

    setState(() {
      _PottingSoilData = initialPottingSoliData;
      _mixingTankData = initialMixingData;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      try {
        // 데이터 갱신
        final pottingSoilData = await potting_soil.generatePottingSoilData();
        final mixingData = await mixing_tank.generateMixingTankData(
            isOperating: deviceOperation.isOperating,
            deviceOperation: deviceOperation,
            context: context);

        setState(() {
          _PottingSoilData = pottingSoilData;
          _mixingTankData = mixingData;
        });
      } catch (e) {
        print("Error fetching data: $e");
      }
    });
  }

  //   // FirebaseService firebaseService = FirebaseService();

  // 현재 선택된 탭 (0: 제품, 1: 유용한 기능)
  int _selectedIndex = 0;

  // 시뮬레이션 FAB 버튼
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "음식물 처리기",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFEF7FF), // 상단바 배경색
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _selectedIndex == 0 ? _buildMainContent() : const functions(),
          // 팝업 버튼 (음식물 처리 관련)
          if (_isExpanded) ...[
            // 음식1 버튼 (처리 가능)
            Transform.translate(
              offset: const Offset(0, -80), // 첫 번째 버튼 위치
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = false; // 팝업 닫기
                    // 처리 가능한 음식 로직
                    mixing_tank.increaseVolume(50.0); // Volume을 10 증가
                    mixing_tank.setDecreaseRate(0.5);
                    _mixingTankData = mixing_tank.generateMixingTankData(
                        isOperating: deviceOperation.isOperating,
                        deviceOperation: deviceOperation, // 객체 전달;
                        context: context); // 변경된 값 반영
                    deviceOperation.startOperation(); // 작동 시작
                  });
                  print("처리 가능한 음식 클릭됨");
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.food_bank),
              ),
            ),
            // 음식2 버튼 (처리 불가능)
            Transform.translate(
              offset: const Offset(0, -140), // 버튼 위치
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlert(
                        title: "경고", // 동적으로 변경 가능
                        content: "이 음식물은 처리할 수 없습니다.", // 동적으로 변경 가능
                        onConfirm: () {
                          // 확인 버튼 클릭 시 동작
                          print("경고창 닫힘");
                        },
                      );
                    },
                  );
                },
                backgroundColor: Colors.grey,
                child: const Icon(Icons.block), // 처리 불가능한 음식 아이콘
              ),
            ),
            // 음식3 버튼 (처리 가능)
            Transform.translate(
              offset: const Offset(0, -200), // 세 번째 버튼 위치
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = false; // 팝업 닫기
                    // 처리 가능한 음식 로직
                    mixing_tank.increaseVolume(20.0); // Volume을 20 증가
                    mixing_tank.setDecreaseRate(2.5);
                    _mixingTankData = mixing_tank.generateMixingTankData(
                        isOperating: deviceOperation.isOperating,
                        deviceOperation: deviceOperation,
                        context: context); // 변경된 값 반영
                    deviceOperation.startOperation(); // 작동 시작
                  });
                  print("처리 가능한 음식 클릭됨");
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.restaurant_menu),
              ),
            ),
          ],

          // 메인 FAB 버튼
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded; // 상태 토글
              });

              print(_isExpanded ? "팝업 버튼 열림" : "팝업 버튼 닫힘");
            },
            backgroundColor: _isExpanded ? Colors.red : Colors.green,
            child: Icon(
              _isExpanded ? Icons.close : Icons.menu, // 상태에 따라 아이콘 변경
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: const Color(0xFFFFFFFF), // 배경색
    );
  }

  // 메인 콘텐츠
  Widget _buildMainContent() {
    // 배양토 상태 계산
    bool PottingSoilIsNormal = _PottingSoilData?['status'] ?? "알 수 없음";

    String PottingSoilStatus = PottingSoilIsNormal ? "정상" : "비정상";
    Color PottingSoilColor = PottingSoilIsNormal ? Colors.green : Colors.red;

    // 교반통 상태 계산
    bool mixingTankIsNormal = _mixingTankData?['status'] ?? "알 수 없음";

    String mixingTankStatus = mixingTankIsNormal ? "정상" : "비정상";
    Color mixingTankColor = mixingTankIsNormal ? Colors.green : Colors.red;

    // 부산물통 용량 상태
    final String _byproductCapacity = "35%";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 이미지 및 제목
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child:
                      const Icon(Icons.recycling, size: 50, color: Colors.teal),
                ),
                const SizedBox(height: 10),
                const Text(
                  "미생물 음식물 처리기",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 작동 상태, 반응통 정리 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusCard(
                "작동 상태",
                deviceOperation.isOperating ? "ON" : "OFF", // 상태에 따라 텍스트 변경
                deviceOperation.isOperating
                    ? Colors.green
                    : Colors.red, // 상태에 따른 색상 변경
                showStopButton: deviceOperation.isOperating, // 정지 버튼을 보여줄지 결정
                deviceOperation: deviceOperation, // DeviceOperation 객체 전달
              ),
              _buildStatusCard(
                "발효중 경과 시간",
                deviceOperation.getElapsedTime(),
                Colors.orange,
                showStopButton: deviceOperation.isOperating,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 모든 운영 제어 버튼 (토글 형태)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildToggleButton("절전", Icons.energy_savings_leaf, Colors.teal),
              _buildToggleButton("제습", Icons.waves, Colors.orange),
              _buildToggleButton("탈취", Icons.cleaning_services, Colors.red),
              _buildToggleButton("배양", Icons.biotech, Colors.pinkAccent),
            ],
          ),
          const SizedBox(height: 20),

          // 부산물통 용량 상태
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "부산물통 용량 상태",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _byproductCapacity,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
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
                "배양토 상태",
                PottingSoilStatus,
                PottingSoilColor,
                () => _showPottingSoilModal(context),
              ),
              _buildInfoBox(
                "교반통 상태",
                mixingTankStatus,
                mixingTankColor,
                () => _showAgitatorModal(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 작동 모드 선택 토글 버튼 빌더
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

  // 정보 박스 빌더
  Widget _buildInfoBox(
      String title, String value, Color color, VoidCallback? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

  //배양토 상태 모달창
  void _showPottingSoilModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double screenWidth = MediaQuery.of(context).size.width;

        // Timer 변수 (모달 내부)
        Timer? modalTimer;

        // 모달 상태 관리
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            // 모달 안의 값이 주기적으로 업데이트되도록 타이머 설정
            modalTimer ??=
                Timer.periodic(const Duration(milliseconds: 1000), (timer) {
              print("모달 타이머 실행");
              modalSetState(() {
                _PottingSoilData = potting_soil.generatePottingSoilData();
              });
            });

            return Container(
              height: screenHeight * 0.5,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 제목
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "배양토 상태",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          modalTimer?.cancel(); // 타이머 중지
                          Navigator.of(context).pop(); // 모달 닫기
                        },
                        icon: Icon(
                          Icons.close,
                          size: screenWidth * 0.06,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // 모달 내용: 온도, 습도, pH 상태
                  Column(
                    children: [
                      _buildModalRow(
                        "온도",
                        "${_PottingSoilData?['temperature']}°C",
                        Icons.mood,
                        _PottingSoilData?['temperatureStatus'],
                        _PottingSoilData?['temperatureStatus'] == "보통"
                            ? Colors.green
                            : _PottingSoilData?['temperatureStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildModalRow(
                        "습도",
                        "${_PottingSoilData?['humidity']}%",
                        Icons.warning,
                        _PottingSoilData?['humidityStatus'],
                        _PottingSoilData?['humidityStatus'] == "보통"
                            ? Colors.green
                            : _PottingSoilData?['humidityStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildModalRow(
                        "pH",
                        "${_PottingSoilData?['ph']}",
                        Icons.mood_bad,
                        _PottingSoilData?['phStatus'],
                        _PottingSoilData?['phStatus'] == "보통"
                            ? Colors.green
                            : _PottingSoilData?['phStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        screenWidth,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 교반통 상태 모달창
  void _showAgitatorModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double screenWidth = MediaQuery.of(context).size.width;

        // Timer 변수 (모달 내부)
        Timer? modalTimer;

        // 모달 상태 관리
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            // 모달 안의 값이 주기적으로 업데이트되도록 타이머 설정
            modalTimer ??=
                Timer.periodic(const Duration(milliseconds: 1000), (timer) {
              modalSetState(() {
                _mixingTankData = mixing_tank.generateMixingTankData(
                    isOperating: deviceOperation.isOperating,
                    deviceOperation: deviceOperation,
                    context: context);
              });
            });

            return Container(
              height: screenHeight * 0.6,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 제목
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "교반통 상태",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          modalTimer?.cancel(); // 타이머 중지
                          Navigator.of(context).pop(); // 모달 닫기
                        },
                        icon: Icon(Icons.close, size: screenWidth * 0.06),
                      ),
                    ],
                  ),
                  const Divider(),

                  // 모달 내용: 온도, 습도, 높이 상태
                  Column(
                    children: [
                      _buildModalRow(
                        "온도",
                        "${_mixingTankData?['temperature']}°C",
                        Icons.mood,
                        _mixingTankData?['temperatureStatus'],
                        _mixingTankData?['temperatureStatus'] == "보통"
                            ? Colors.green
                            : _mixingTankData?['temperatureStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        screenWidth,
                      ),
                      const SizedBox(height: 16),
                      _buildModalRow(
                        "습도",
                        "${_mixingTankData?['humidity']}%",
                        Icons.warning,
                        _mixingTankData?['humidityStatus'],
                        _mixingTankData?['humidityStatus'] == "보통"
                            ? Colors.green
                            : _mixingTankData?['humidityStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        screenWidth,
                      ),
                      const SizedBox(height: 16),
                      _buildModalRow(
                        "높이",
                        "${_mixingTankData?['volume']}",
                        Icons.mood_bad,
                        _mixingTankData?['volumeStatus'],
                        _mixingTankData?['volumeStatus'] == "보통"
                            ? Colors.green
                            : _mixingTankData?['volumeStatus'] == "높음"
                                ? Colors.red
                                : Colors.lightBlue,
                        screenWidth,
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
                          modalSetState(() {
                            mixing_tank.decreaseVolume(10.0); // 10 감소
                            _mixingTankData =
                                mixing_tank.generateMixingTankData(
                                    isOperating: deviceOperation.isOperating,
                                    deviceOperation: deviceOperation,
                                    context: context);
                          });
                        },
                        child: const Text("감소"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          modalSetState(() {
                            mixing_tank.increaseVolume(10.0); // 10 증가
                            _mixingTankData =
                                mixing_tank.generateMixingTankData(
                                    isOperating: deviceOperation.isOperating,
                                    deviceOperation: deviceOperation,
                                    context: context);
                          });
                        },
                        child: const Text("증가"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
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
}
