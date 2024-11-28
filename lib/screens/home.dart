import 'package:flutter/material.dart';
import '../components/device_card.dart';
import 'device/device_on.dart';

// TODO: "스마트 루틴" 블럭 padding 수정
class Home extends StatefulWidget {
  final String userId;
  final String userName;

  const Home({
    super.key,
    required this.userId,
    required this.userName,
    required String title,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isNewzenOn = false;
  bool isFridgeOn = false;
  bool isTiiunOn = false;
  bool isMicrowaveOn = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-1.0, -1.0),
          radius: 1.0,
          colors: [
            Color(0xFFBDD2E3),
            Color(0xFFDAEDF3),
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF4F4F4F),
                      fontWeight: FontWeight.bold,
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
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: kBottomNavigationBarHeight + bottomPadding + 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
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
                      icon: 'assets/images/home/fridge.png',
                      title: '냉장고',
                      isOn: isFridgeOn,
                      onTogglePower: () {
                        setState(() {
                          isFridgeOn = !isFridgeOn;
                        });
                      },
                      onIconTap: isFridgeOn ? () {} : null,
                    ),
                    DeviceCard(
                      icon: 'assets/images/home/tiiun.png',
                      title: '틔운 미니',
                      isOn: isTiiunOn,
                      onTogglePower: () {
                        setState(() {
                          isTiiunOn = !isTiiunOn;
                        });
                      },
                      onIconTap: isTiiunOn ? () {} : null,
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
                      onIconTap: isMicrowaveOn ? () {} : null,
                    ),
                  ],
                ),
                const SizedBox(height: 0),
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
                // TODO: bottomNavigationBar 아이콘 수정
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
