import 'package:flutter/material.dart';

import '../../components/custom_alert.dart';

class ByproductManager {
  double byproductCapacity;
  bool isAlertShown = false; // 알람 중복 방지 플래그

  // 생성자를 통해 초기 용량을 설정
  ByproductManager({required this.byproductCapacity});

  // 부산물 용량 증가 함수
  void increaseCapacity(BuildContext context, {double increment = 5.0}) {
    if (byproductCapacity < 100) {
      byproductCapacity += increment; // 증가값 적용
      byproductCapacity = byproductCapacity.clamp(0.0, 100.0); // 0~100 범위 제한
    }

    // 용량 초과 시 CustomAlert 호출
    if (byproductCapacity > 80 && !isAlertShown) {
      // isAlertShown = true; // 알람 중복 방지
      _showAlert(context, "경고", "부산물통 용량이 80%를 초과했습니다.\n조치를 취해주세요.");
    }
  }

  // 부산물 용량 감소 함수
  void decreaseCapacity() {
    if (byproductCapacity > 0) {
      byproductCapacity -= 5; // 5% 감소
    }
    print("용량 감소: $byproductCapacity");
  }

  // 부산물 Bar 색상 결정 함수
  Color getBarColor(double value) {
    if (value <= 60) {
      // 60 이하일 때는 초록색
      return Colors.green;
    } else if (value <= 70) {
      // 60~70 구간: 초록색에서 노란색으로 점진적 변화
      double normalizedValue = (value - 60) / 10; // 60~70을 0.0~1.0로 정규화
      return Color.lerp(Colors.green, Colors.yellow.shade700, normalizedValue)!;
    } else if (value <= 80) {
      // 70~80 구간: 노란색에서 주황색으로 점진적 변화
      double normalizedValue = (value - 70) / 10; // 70~80을 0.0~1.0로 정규화
      return Color.lerp(
          Colors.yellow.shade700, Colors.orange, normalizedValue)!;
    } else {
      // 80~100 구간: 주황색에서 빨간색으로 점진적 변화
      double normalizedValue = (value - 80) / 20; // 80~100을 0.0~1.0로 정규화
      return Color.lerp(Colors.orange, Colors.red, normalizedValue)!;
    }
  }
}

// 알림창 표시 메서드
void _showAlert(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlert(
        title: title,
        content: content,
        onConfirm: () {
          print("CustomAlert 확인 버튼 클릭됨");
          // Navigator.of(context).pop(); // 알림창 닫기
        },
      );
    },
  );
}
