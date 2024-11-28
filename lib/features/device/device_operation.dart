import 'package:flutter/material.dart';
import 'dart:async';

class DeviceOperation {
  bool isOperating; // 작동 상태 (ON/OFF)
  ValueNotifier<int> elapsedTime; // 경과 시간 (초 단위)를 ValueNotifier로 변경
  Timer? _timer; // 타이머 변수

  DeviceOperation({this.isOperating = false, int initialElapsedTime = 0})
      : elapsedTime = ValueNotifier(initialElapsedTime);

  // 작동 시작
  void startOperation() {
    if (isOperating) return; // 이미 작동 중이면 무시
    isOperating = true;

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      elapsedTime.value++;
    });
  }

  // 작동 중지
  void stopOperation() {
    isOperating = false;
    _timer?.cancel();
  }

  // 상태 리셋
  void resetOperation() {
    stopOperation();
    elapsedTime.value = 0;
  }

  // 경과 시간 반환 (포맷: MM:SS)
  String getElapsedTime() {
    final minutes = (elapsedTime.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedTime.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
