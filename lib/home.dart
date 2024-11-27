import 'package:flutter/material.dart';
import 'screens/device/device_on.dart';
import 'screens/device/device_off.dart';

class Home extends StatefulWidget {
  final String userId; // 로그인된 유저 ID 전달받기

  const Home({Key? key, required this.userId, required String title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isnewzenOn = false; // 미생물 음식물 처리기 상태
  bool isMicrowaveOn = false; // 전자레인지 상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "${widget.userId} 홈", // 로그인된 유저의 ID로 표시
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              // 추가 버튼 기능
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // 알림 버튼 기능
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // SVG 이미지를 표시
              Column(
                children: [
                  Image.asset(
                    "images/test.png", // SVG 파일 경로
                    height: 120, // 높이 설정
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "임시 이미지", // 텍스트를 "임시 이미지"로 변경
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 미생물 음식물 처리기와 전자레인지 카드
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2, // 카드 비율 수정
                ),
                children: [
                  _buildDeviceCard(
                    icon: Icons.recycling,
                    title: "미생물 음식물 처리기",
                    isOn: isnewzenOn,
                    onPressed: () {
                      setState(() {
                        isnewzenOn = !isnewzenOn; // 상태 토글
                      });
                    },
                    onIconTap: () {
                      if (isnewzenOn) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const DeviceOn()),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const DeviceOff()),
                        );
                      }
                    },
                  ),
                  _buildDeviceCard(
                    icon: Icons.microwave,
                    title: "전자레인지",
                    isOn: isMicrowaveOn,
                    onPressed: () {
                      setState(() {
                        isMicrowaveOn = !isMicrowaveOn; // 상태 토글
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 기기 카드 빌더
  Widget _buildDeviceCard({
    required IconData icon,
    required String title,
    required bool isOn,
    required VoidCallback onPressed,
    VoidCallback? onIconTap, // 아이콘 클릭 이벤트 추가
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0), // 패딩 조정
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onIconTap, // 아이콘 클릭 시 호출
              child: Icon(icon, size: 40, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Spacer(), // 남은 공간을 밀어줌으로써 버튼의 위치 조정
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isOn ? Colors.teal : Colors.grey, // 상태에 따른 버튼 색상
                minimumSize: const Size(80, 36), // 버튼 크기 조정
              ),
              child: Text(
                isOn ? "켜짐" : "꺼짐",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}