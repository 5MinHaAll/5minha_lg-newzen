import 'dart:math';
import '../newzen/device_operation.dart';
import 'package:flutter/material.dart';
import '../newzen/custom_alert.dart'; // CustomAlert가 정의된 파일을 import

class RandomDataService {
  final Random _random = Random();

  // DeviceOperation 객체 생성
  DeviceOperation deviceOperation = DeviceOperation();

  double _currentVolume = 90.0; // 초기 용량
  double? _previousVolume; // 이전 용량
  double _dynamicDecreaseRate = 0.5; // 동적으로 계산된 감소 속도

  bool _isAlertShown = false; // 알림 표시 상태 관리

  // 감소율 설정 메소드
  void setDecreaseRate(double rate) {
    if (rate < 0) {
      print("감소율은 0 이상이어야 합니다.");
      return;
    }
    _dynamicDecreaseRate = rate;
    print("감소율이 $rate로 설정되었습니다.");
  }

  // _currentVolume 감소 메소드
  void decreaseVolume(double amount) {
    if (amount < 0) {
      print("감소 값은 0 이상이어야 합니다.");
      return;
    }
    _previousVolume ??= _currentVolume; // 이전 값을 업데이트
    _currentVolume = (_currentVolume - amount).clamp(0.0, 200.0); // 0 ~ 200 제한
    print("Volume 감소: $_currentVolume (이전: $_previousVolume)");
  }

  // _currentVolume 증가 메소드
  void increaseVolume(double amount) {
    // 현재 값을 이전 값으로 저장 (최초에만, 이전 값이 null일 때만 적용됨.)
    _previousVolume ??= _currentVolume - 80;
    // 해당 값에 따라 작동 먹출 수 있음.
    print("이전 값은 $_previousVolume");
    _currentVolume = (_currentVolume + amount).clamp(0.0, 200.0); // ㅅ0 ~ 200 제한
  }

  Map<String, dynamic> generateMixingTankData(
      {bool isOperating = false,
      DeviceOperation? deviceOperation,
      required BuildContext context}) {
    print("generateMixingTankData을 호출합니다.");

    final int temperature = 35 + _random.nextInt(20); // 35 ~ 55
    final int humidity = 40 + _random.nextInt(20); // 40 ~ 60
    bool? mixingTankIsNormal;

    mixingTankIsNormal = _getTemperatureStatus(temperature) == "보통" &&
        _getHumidityStatus(humidity) == "보통" &&
        _getVolumnStatus(_currentVolume, context) == "보통";

    // '작동' 상태라면 volume 값을 줄임
    if (isOperating) {
      if (_currentVolume <= _previousVolume! + _dynamicDecreaseRate) {
        print("이전 무게는 $_previousVolume");
        deviceOperation?.resetOperation(); // DeviceOperation 객체를 통해 작동 중지
        // deviceOperation?.stopOperation(); // 자동으로 작동 중지 했을 때 발효하는데 걸린 시간을 보고 싶다면?!
      } else {
        print("무게 변화 감지: 작동 유지");
      }
      _currentVolume = (_currentVolume - _dynamicDecreaseRate)
          .clamp(0.0, 200.0); // 0 ~ 70 범위로 제한
    }

    // _currentVolume 값을 소수점 2자리로 반올림
    final double roundedVolume =
        double.parse(_currentVolume.toStringAsFixed(2));

    return {
      'timestamp': DateTime.now().toIso8601String(), // 현재 시간
      'temperature': temperature,
      'temperatureStatus': _getTemperatureStatus(temperature),
      'humidity': humidity,
      'humidityStatus': _getHumidityStatus(humidity),
      'volume': roundedVolume,
      'volumeStatus': _getVolumnStatus(roundedVolume, context),
      'status': mixingTankIsNormal
    };
  }

  Map<String, dynamic> generatePottingSoilData() {
    final int temperature = 35 + _random.nextInt(20); // 35 ~ 55
    final int humidity = 40 + _random.nextInt(20); // 40 ~ 60
    final double rawPh = 6.4 + _random.nextDouble() * 2.1; // 6.5 ~ 8.5
    final double ph = (rawPh * 10).ceilToDouble() / 10;
    bool? pottingSoilIsNormal;
    pottingSoilIsNormal = _getTemperatureStatus(temperature) == "보통" &&
        _getHumidityStatus(humidity) == "보통" &&
        _getPhStatus(ph) == "보통";

    return {
      'timestamp': DateTime.now().toIso8601String(), // 현재 시간
      'temperature': temperature,
      'temperatureStatus': _getTemperatureStatus(temperature),
      'humidity': humidity,
      'humidityStatus': _getHumidityStatus(humidity),
      'ph': ph,
      'phStatus': _getPhStatus(ph),
      'status': pottingSoilIsNormal
    };
  }

  String _getTemperatureStatus(int temperature) {
    if (temperature < 35) {
      return "낮음";
    } else if (temperature <= 55) {
      return "보통";
    } else {
      return "높음";
    }
  }

  String _getHumidityStatus(int humidity) {
    if (humidity < 40) {
      return "낮음";
    } else if (humidity <= 60) {
      return "보통";
    } else {
      return "높음";
    }
  }

  String _getPhStatus(double ph) {
    if (ph < 6.5) {
      return "낮음";
    } else if (ph <= 8.5) {
      return "보통";
    } else {
      return "높음";
    }
  }

  // 교반통안의 배양토 높이에 따른 알람!
  String _getVolumnStatus(double volume, BuildContext context) {
    if (volume < 20.0) {
      if (!_isAlertShown) {
        _isAlertShown = true; // 알림 표시 상태 업데이트
        print("알림 호출!");
        _showCustomAlert(context, "알림", "배양토 채워줘야 해요!");
      }
      return "낮음";
    } else if (volume > 180.0) {
      if (!_isAlertShown) {
        _isAlertShown = true; // 알림 표시 상태 업데이트
        _showCustomAlert(context, "알림", "용량의 80%가 찼습니다. 천천히 넣어주세요.");
      }
      return "높음";
    } else {
      _isAlertShown = false; // 알림 표시 상태 초기화
      return "보통";
    }
  }

// CustomAlert를 사용하는 알림 창 메소드
  void _showCustomAlert(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 제목
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // 내용
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                // 확인 버튼
                ElevatedButton(
                  onPressed: () {
                    print("알림창 확인 버튼 클릭됨");
                    Navigator.of(context).pop(); // 알림창 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("확인"),
                ),
                const SizedBox(height: 12),
                // 홈으로 이동 버튼
                ElevatedButton(
                  onPressed: () {
                    print("홈 화면으로 이동");
                    Navigator.of(context)
                        .pushReplacementNamed('/home'); // Home 화면으로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("홈으로 이동"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _showCustomAlert(BuildContext context, String title, String content) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CustomAlert(
  //         title: title,
  //         content: content,
  //         onConfirm: () {
  //           print("알림창 확인 버튼 클릭됨");
  //           Navigator.of(context).pop(); // 알림창 닫기
  //         },
  //       );
  //     },
  //   );
  // }
}
