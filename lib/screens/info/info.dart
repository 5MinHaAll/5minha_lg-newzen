import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() =>
      _InfoState();
}

class _InfoState
    extends State<Info>
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
      appBar: AppBar(
        // 뒤로 가기 버튼
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 이전 화면으로 이동
          },
        ),
        title: Text("미생물 관리"), // 제목
        actions: [
          IconButton(
            icon: Icon(Icons.search), // 검색 아이콘
            onPressed: () {
              // 검색 기능 추가 가능
            },
          ),
        ],
        backgroundColor: Color(0xFFFEF7FF), // 상단바 배경색
        elevation: 0, // 그림자 효과 제거
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black, // 선택된 탭 텍스트 색상
          unselectedLabelColor: Colors.grey, // 선택되지 않은 탭 텍스트 색상
          indicatorColor: Color(0xFF65558F), // 선택된 탭 아래 강조선 색상
          tabs: [
            Tab(text: "정보"), // 첫 번째 탭
            Tab(text: "음식"), // 두 번째 탭
          ],
        ),
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
