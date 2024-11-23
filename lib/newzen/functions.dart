import 'package:flutter/material.dart';

import '../functions/detect_main.dart';
import '../functions/info.dart';

class functions extends StatelessWidget {
  const functions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 주요 콘텐츠를 세로 방향으로 배치
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯을 수평으로 늘림
          children: [
            const SizedBox(height: 45), // 카드 간 간격

            // "미생물 관리" 카드
            Stack(
              children: [
                _buildFeatureCard(
                  "미생물 관리", // 카드 제목
                  "", // 카드 설명
                  Icons.arrow_forward_ios, // 오른쪽 화살표 아이콘
                  Color(0xFFFEF7FF), // 카드 배경 색상
                      () {
                    // 카드 클릭 시 manageInfoPage로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Info()),
                    );
                  },
                ),
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // 버튼 클릭 이벤트 처리
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Detection()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink, // 버튼 배경색
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "처리 가능한 음식물",
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45), // 카드 간 간격

            // "소모품 정보" 카드
            _buildFeatureCard(
              "소모품 정보",
              "내 제품에 필요한 소모품을 확인해보세요.",
              null,
              Color(0xFFFEF7FF),
                  () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바를 즉시 숨김
                // 클릭 시 스낵바 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('소모품 정보 페이지로 이동합니다.')),
                );
              },
            ),
            const SizedBox(height: 45),

            // "에너지 모니터링" 카드
            _buildFeatureCard(
              "에너지 모니터링",
              "전력 사용량",
              Icons.arrow_forward_ios,
              Color(0xFFDED8E1),
                  () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바를 즉시 숨김
                // 클릭 시 스낵바 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('에너지 모니터링 페이지로 이동합니다.')),
                );
              },
            ),
            const SizedBox(height: 45),

            // 두 개의 카드(스마트 진단, 제품 사용설명서)를 가로로 배치
            Row(
              children: [
                // "스마트 진단" 카드
                Expanded(
                  child: _buildFeatureCard(
                    "스마트 진단",
                    "최근 진단 결과 없음",
                    null, // 아이콘 없음
                    Color(0xFFDED8E1),
                        () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바를 즉시 숨김
                      // 클릭 시 스낵바 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('스마트 진단 페이지로 이동합니다.')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16), // 카드 간 간격
                // "제품 사용설명서" 카드
                Expanded(
                  child: _buildFeatureCard(
                    "제품 사용설명서",
                    "사용법이 궁금하신가요?",
                    null, // 아이콘 없음
                    Color(0xFFDED8E1),
                        () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 현재 스낵바를 즉시 숨김
                      // 클릭 시 스낵바 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('제품 사용설명서 페이지로 이동합니다.')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 카드 위젯 생성 함수
  Widget _buildFeatureCard(String title, String subtitle, IconData? icon,
      Color backgroundColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // 카드 클릭 이벤트
      child: Container(
        padding: const EdgeInsets.all(24.0), // 카드 내부 여백
        decoration: BoxDecoration(
          color: backgroundColor, // 배경색 투명도 조정
          // borderRadius: BorderRadius.circular(12), // 둥근 모서리
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 위쪽 정렬
          children: [
            // 텍스트 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // 카드 제목
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // 텍스트 색상
                    ),
                  ),
                  const SizedBox(height: 8), // 텍스트 간격
                  Text(
                    subtitle, // 카드 설명
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54, // 설명 텍스트 색상
                    ),
                  ),
                ],
              ),
            ),
            if (icon != null)
              Icon(
                icon, // 아이콘 표시 (icon이 null이 아닌 경우에만)
                color: Colors.black45, // 아이콘 색상
              ),
          ],
        ),
      ),
    );
  }
}