import 'package:flutter/material.dart';
import '../../components/appbar_tab.dart';

class InfoFood extends StatefulWidget {
  const InfoFood({Key? key}) : super(key: key);

  @override
  _InfoFoodState createState() => _InfoFoodState();
}

class _InfoFoodState extends State<InfoFood>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        title: "음식물 분류 가이드",
        tabController: _tabController,
        tabs: const ["정보", "음식"],
        // backgroundColor: const Color(0xFFFEF7FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 검색 기능
            },
          ),
        ],
        tabColor: Colors.black,
        unselectedTabColor: Colors.grey,
        indicatorColor: const Color(0xFF65558F),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // '정보' 탭의 내용
          Center(
            child: Text(
              "여기에 미생물 관련 정보를 표시하세요.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          // '음식' 탭의 내용
          Center(
            child: Text(
              "여기에 미생물 관련 음식을 표시하세요.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFFFFFFF),
    );
  }
}
