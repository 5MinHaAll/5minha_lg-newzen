import 'dart:async';

class DeviceOperation {
  bool isOperating; // 작동 상태 (ON/OFF)
  int elapsedTime; // 경과 시간 (초 단위)
  Timer? _timer; // 타이머 변수

  // 생성자
  DeviceOperation({this.isOperating = false, this.elapsedTime = 0});

  // 작동 시작
  void startOperation() {
    if (isOperating) return; // 이미 작동 중이면 무시
    isOperating = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime++;
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
    elapsedTime = 0;
  }

  // 경과 시간 반환 (포맷: MM:SS)
  String getElapsedTime() {
    if (!isOperating && elapsedTime == 0) {
      // 작동이 중지되었고, 경과 시간이 0일 경우 "00:00" 반환
      return "00:00";
    }
    final minutes = (elapsedTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedTime % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
