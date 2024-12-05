import 'dart:math';
import '../features/device/device_operation.dart';
import 'package:flutter/material.dart';
import '../components/custom_alert.dart'; // CustomAlert가 정의된 파일을 import

class RandomDataService {
  final Random _random = Random();

  // DeviceOperation 객체 생성
  DeviceOperation deviceOperation = DeviceOperation();

  double _currentVolume = 90.0; // 초기 용량
  double? _previousVolume; // 이전 용량
  double _dynamicDecreaseRate = 0.5; // 동적으로 계산된 감소 속도
  double _amount = 0; // 음식 무게?! 높이 무튼

  bool _isAlertShown = false; // 알림 표시 상태 관리

  // 초기화 메서드
  void reset() {
    _currentVolume = 90.0; // 초기 용량으로 재설정
    _previousVolume = null; // 이전 용량 초기화
    _dynamicDecreaseRate = 0.5; // 감소율 초기화
    print("RandomDataService가 초기화되었습니다.");
  }

  // 감소율 설정 메소드
  void setDecreaseRate(double rate) {
    if (rate < 0) {
      print("감소율은 0 이상이어야 합니다.");
      return;
    }
    _dynamicDecreaseRate = rate;
    print("감소율이 $rate로 설정되었습니다.");
  }

// Setter: 값을 설정
  void setAmount(double amount) {
    if (amount < 0) {
      print("추가 음식은 0 이상이어야 합니다.");
      return;
    }
    _amount = amount;
    print("추가량이 $amount로 설정되었습니다.");
  }

// Getter: 값을 반환
  double getAmount() {
    return _amount;
  }

  // _currentVolume 감소 메소드
  void decreaseVolume(double amount) {
    if (amount < 0) {
      print("감소 값은 0 이상이어야 합니다.");
      return;
    }
    _previousVolume ??= _currentVolume; // 이전 값을 업데이트
    _currentVolume = (_currentVolume - amount).clamp(0.0, 200.0); // 0 ~ 200 제한
  }

  // _currentVolume 증가 메소드
  void increaseVolume(double amount) {
    // 현재 값을 이전 값으로 저장 (최초에만, 이전 값이 null일 때만 적용됨.)
    _previousVolume ??= _currentVolume;
    // 해당 값에 따라 작동 먹출 수 있음.
    print("이전 값은 $_previousVolume");
    _currentVolume = (_currentVolume + amount).clamp(0.0, 200.0); // 0 ~ 200 제한
  }

  // 교반통 상태
  // 온도, 습도, 높이
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
    bool shouldIncreaseByproduct = false; // 부산물 용량 증가 여부 플래그
    if (isOperating) {
      if (_currentVolume <= _previousVolume! + _dynamicDecreaseRate) {
        // if (_currentVolume <= 30 + _dynamicDecreaseRate) {
        print("이전 무게는 $_previousVolume");

        shouldIncreaseByproduct = true; // 부산물 용량 증가 플래그 설정

        deviceOperation?.resetOperation(); // DeviceOperation 객체를 통해 작동 중지
        // deviceOperation?.stopOperation();  // 자동으로 작동 중지 했을 때 발효하는데 걸린 시간을 보고 싶다면?!
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
      'status': mixingTankIsNormal,
      'shouldIncreaseByproduct': shouldIncreaseByproduct, // 부산물 증가 여부 반환
    };
  }

  // 배양토 상태
  // 온도 습도, pH
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
    if (volume <= 30.0) {
      if (!_isAlertShown) {
        _isAlertShown = true;
        // 알림 창 표시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlert(
              title: "알림",
              content: "배양토를 채워줘야 해요!",
              onConfirm: () {
                print("CustomAlert 확인 버튼 클릭됨");
                // Navigator.of(context).pop(); // 알림창 닫기
              },
            );
          },
        );
      }
      return "낮음";
    } else if (volume >= 180.0) {
      if (!_isAlertShown) {
        _isAlertShown = true;
        // 알림 창 표시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlert(
              title: "알림",
              content: "음식물통의 90%가 찼습니다.\n천천히 넣어주세요.",
              onConfirm: () {
                print("CustomAlert 확인 버튼 클릭됨");
                // Navigator.of(context).pop(); // 알림창 닫기
              },
            );
          },
        );
      }
      return "높음";
    } else {
      _isAlertShown = false; // 알림 상태 초기화
      return "보통";
    }
  }
}
