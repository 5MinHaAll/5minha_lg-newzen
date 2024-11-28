import 'package:flutter/material.dart';
import '../components/device_card.dart';
import 'device/device_on.dart';
import 'device/device_off.dart';

class Home extends StatefulWidget {
  final String userId; // 로그인된 유저 ID 전달받기
  final String userName; // 로그인된 유저 이름 전달받기

  const Home(
      {Key? key,
      required this.userId,
      required String title,
      required this.userName})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isNewzenOn = false;
  bool isMicrowaveOn = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-1.0, -1.0), // 좌측 상단
          radius: 1.0,
          colors: [
            Color(0xFFBDD2E3), // 좌측 상단 색상
            Color(0xFFDAEDF3), // 중앙 색상
          ],
          stops: [0.2, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Text(
                "${widget.userName} 홈",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    DeviceCard(
                      icon: 'assets/images/home/newzen.png',
                      title: '음식물 처리기',
                      isOn: isNewzenOn,
                      onTogglePower: () {
                        setState(() {
                          isNewzenOn = !isNewzenOn;
                        });
                      },
                      onIconTap: isNewzenOn
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DeviceOn(),
                                ),
                              );
                            }
                          : null,
                    ),
                    DeviceCard(
                      icon: 'assets/images/home/microwave.png',
                      title: '전자레인지',
                      isOn: isMicrowaveOn,
                      onTogglePower: () {
                        setState(() {
                          isMicrowaveOn = !isMicrowaveOn;
                        });
                      },
                      onIconTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "스마트 루틴",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFFFE8CC),
                      child: Icon(Icons.timer, color: Colors.orange),
                    ),
                    title: Text("루틴 알아보기"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
                const SizedBox(height: 100), // 하단 여백 추가
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
            backgroundColor: Colors.white,
            elevation: 0,
            shape: const CircleBorder(),
            onPressed: () {},
            child: Image.asset(
              'assets/icons/home/ic_ai_chat.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: Container(
            color: Colors.transparent,
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  activeIcon: Icon(Icons.explore),
                  label: '디스커버',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  label: '리포트',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: '메뉴',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
