import 'package:flutter/material.dart';
import 'useful_features_page.dart'; // 유용한 기능 페이지 import

class FoodProcessorOnPage extends StatefulWidget {
  const FoodProcessorOnPage({Key? key}) : super(key: key);

  @override
  _FoodProcessorOnPageState createState() => _FoodProcessorOnPageState();
}

class _FoodProcessorOnPageState extends State<FoodProcessorOnPage> {
  // 현재 활성화된 모드 (초기값은 아무 것도 선택되지 않은 상태)
  String? _activeMode;

  // 배양토 상태 초기값
  String _temperatureStatus = "양호";
  String _humidityStatus = "주의";
  String _phStatus = "보통";

  // 교반통 상태 초기값 (고정)
  final String _agitatorTemperatureStatus = "양호";
  final String _agitatorHumidityStatus = "양호";

  // 부산물통 용량 상태
  final String _byproductCapacity = "35%";

  // 현재 선택된 탭 (0: 제품, 1: 유용한 기능)
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "미생물 음식물 처리기",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _selectedIndex == 0 ? _buildMainContent() : const UsefulFeaturesPage(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // 메인 콘텐츠
  Widget _buildMainContent() {
    // 배양토 상태 계산
    bool isCultivationNormal = _temperatureStatus == "양호" &&
        _humidityStatus == "보통" &&
        _phStatus == "보통";

    String cultivationStatus = isCultivationNormal ? "정상" : "비정상";
    Color cultivationColor = isCultivationNormal ? Colors.green : Colors.red;

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
                  child: const Icon(Icons.recycling, size: 50, color: Colors.teal),
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
              _buildStatusCard("작동 상태", "ON", Colors.teal),
              _buildStatusCard("발효중 경과 시간", "00:30", Colors.orange),
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
              _buildToggleButton("배양", Icons.biotech, Colors.grey),
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
                cultivationStatus,
                cultivationColor,
                    () => _showCultivationModal(context),
              ),
              _buildInfoBox(
                "교반통 상태",
                "정상",
                Colors.green,
                    () => _showAgitatorModal(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 토글 버튼 빌더
  Widget _buildToggleButton(String label, IconData icon, Color color) {
    final bool isActive = _activeMode == label; // 현재 모드와 비교하여 활성화 여부 결정
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeMode = label; // 클릭한 버튼을 활성화 상태로 변경
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

  // 상태 카드
  Widget _buildStatusCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
  Widget _buildInfoBox(String title, String value, Color color, VoidCallback? onTap) {
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
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

  // 배양토 상태 모달창
  void _showCultivationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 제목
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "배양토 상태",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),

              // 모달 내용: 온도, 습도, pH 상태
              Column(
                children: [
                  _buildModalRow(
                    "온도",
                    "23°C",
                    Icons.mood,
                    _temperatureStatus,
                    _temperatureStatus == "양호"
                        ? Colors.green
                        : _temperatureStatus == "주의"
                        ? Colors.red
                        : Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildModalRow(
                    "습도",
                    "60%",
                    Icons.warning,
                    _humidityStatus,
                    _humidityStatus == "양호"
                        ? Colors.green
                        : _humidityStatus == "주의"
                        ? Colors.red
                        : Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildModalRow(
                    "pH",
                    "6.5",
                    Icons.mood_bad,
                    _phStatus,
                    _phStatus == "양호"
                        ? Colors.green
                        : _phStatus == "주의"
                        ? Colors.red
                        : Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 교반통 상태 모달창
  void _showAgitatorModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 제목
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "교반통 상태",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),

              // 모달 내용: 온도, 습도 상태
              Column(
                children: [
                  _buildModalRow(
                    "온도",
                    "23°C",
                    Icons.mood,
                    _agitatorTemperatureStatus,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildModalRow(
                    "습도",
                    "55%",
                    Icons.mood,
                    _agitatorHumidityStatus,
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 모달창 행 빌더
  Widget _buildModalRow(String label, String value, IconData icon, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                status,
                style: TextStyle(
                  fontSize: 16,
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