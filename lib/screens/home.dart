import 'package:flutter/material.dart';
import '../components/device_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../screens/device/device.dart';
import '../screens/device/device_foodon.dart';

import '../components/appbar_home.dart';
import '../components/bottom_nav_bar.dart';

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
  bool isFoodOnOn = false;
  bool isMicrowaveOn = false;
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final textTheme = Theme.of(context).textTheme;

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
        appBar: HomeAppBar(userName: widget.userName),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: kBottomNavigationBarHeight + bottomPadding + 200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.3,
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
                        // DeviceCard(
                        //   icon: 'assets/images/home/foodon.png',
                        //   title: '푸디온',
                        //   isOn: isFoodOnOn,
                        //   onTogglePower: () {
                        //     setState(() {
                        //       isFoodOnOn = !isFoodOnOn;
                        //     });
                        //   },
                        //   // TODO: foodON
                        //   // onIconTap: isFoodOnOn
                        //   //     ? () {
                        //   //         Navigator.push(
                        //   //           context,
                        //   //           MaterialPageRoute(
                        //   //             builder: (context) => const DeviceOn(),
                        //   //           ),
                        //   //         );
                        //   //       }
                        //   //     : null,
                        // ),
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
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "스마트 루틴",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right,
                              size: 24, color: Colors.black54),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 22,
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 14, // CircleAvatar 크기
                              backgroundColor: Color(0xFFFFE8CC),
                              child: Icon(Icons.timer,
                                  color: Colors.orange, size: 18), // 아이콘 크기
                            ),
                            const SizedBox(width: 10), // 아이콘과 텍스트 사이 간격
                            Text(
                              "루틴 알아보기",
                              style: textTheme.titleSmall?.copyWith(
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: kBottomNavigationBarHeight + bottomPadding,
                child: Image.asset(
                  'assets/images/home/3d_man.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
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
              'assets/icons/home/ic_fab.png',
              width: 32,
              height: 32,
            ),
          ),
        ),
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
