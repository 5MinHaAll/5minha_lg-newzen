import 'package:flutter/material.dart';

class UsefulFeaturesPage extends StatelessWidget {
  const UsefulFeaturesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 미생물 관리 + 처리 가능한 음식물 버튼
            _buildFeatureWithButton(
              "미생물 관리",
              Colors.teal,
              "처리 가능한 음식물",
                  () {
                // 처리 가능한 음식물 버튼 클릭 이벤트
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const FoodDetectionPage(),
                //   ),
                // );
              },
            ),

            const SizedBox(height: 16),

            // 소모품 정보
            _buildFeatureCard("소모품 정보", Colors.orange, context),

            const SizedBox(height: 16),

            // 에너지 모니터링
            _buildFeatureCard("에너지 모니터링", Colors.blue, context),

            const SizedBox(height: 16),

            // 진단
            _buildFeatureCard("진단", Colors.green, context),

            const SizedBox(height: 16),

            // 메뉴얼
            _buildFeatureCard("메뉴얼", Colors.purple, context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureWithButton(
      String title,
      Color color,
      String buttonText,
      VoidCallback buttonAction,
      ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: buttonAction,
            icon: const Icon(Icons.fastfood, size: 16),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: color.withOpacity(0.2),
              foregroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 카드 클릭 시 정보 다이얼로그 표시
        _showInfoDialog(context, title, "$title에 대한 자세한 정보를 여기에 표시합니다.");
      },
      child: Container(
        height: 100, // 모든 카드의 높이를 동일하게 설정
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }
}