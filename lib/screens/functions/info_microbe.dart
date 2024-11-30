import 'package:flutter/material.dart';
import '../../components/appbar_tab.dart';

class InfoMicrobe extends StatefulWidget {
  const InfoMicrobe({Key? key}) : super(key: key);

  @override
  _InfoMicrobeState createState() => _InfoMicrobeState();
}

class _InfoMicrobeState extends State<InfoMicrobe>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // TabController 초기화: 두 개의 탭
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // TabController 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        title: "미생물 관리",
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
