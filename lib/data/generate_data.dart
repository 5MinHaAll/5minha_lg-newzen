import 'dart:math';

class RandomDataService {
  final Random _random = Random();

  double _currentVolume = 70.0; // 초기 용량
  double? _previousVolume;      // 이전 용량
  final double _baseDecreaseRate = 0.1; // 기본 감소 속도
  double _dynamicDecreaseRate = 0.1; // 동적으로 계산된 감소 속도

  // _currentVolume 증가 메소드
  void increaseVolume(double amount) {
    _previousVolume = _currentVolume; // 현재 값을 이전 값으로 저장
    _currentVolume = (_currentVolume + amount).clamp(0.0, 200.0); // 0 ~ 200 제한
    _updateDecreaseRate(amount); // 증가량에 따라 감소 속도 업데이트
  }

  // 증가량에 따른 감소 속도 업데이트
  void _updateDecreaseRate(double increaseAmount) {
    if (_currentVolume > _previousVolume! + increaseAmount * 0.5) {
      _dynamicDecreaseRate = 5.0; // 증가량의 50%보다 클 경우 5만큼 감소
    } else if (_currentVolume > _previousVolume! + increaseAmount * 0.2) {
      _dynamicDecreaseRate = 1.0; // 증가량의 20%보다 클 경우 1만큼 감소
    } else if (_currentVolume > _previousVolume! + increaseAmount * 0.1) {
      _dynamicDecreaseRate = 0.0; // 증가량의 10%보다 클 경우 감소 없음
    } else {
      _dynamicDecreaseRate = _baseDecreaseRate; // 기본 감소 속도 사용
    }
  }

  // 현재 무게와 이전 무게를 비교하여 변화가 없으면 작동을 멈추는 메소드
  void checkAndStopOperation(Function resetOperation) {
    if (_currentVolume == _previousVolume) {
      print("무게 변화 없음: 작동 중지");
      resetOperation();
    } else {
      print("무게 변화 감지: 작동 유지");
    }
  }

  Map<String, dynamic> generateMixingTankData({bool isOperating = false}) {
    final int temperature = 35 + _random.nextInt(20); // 35 ~ 55
    final int humidity = 40 + _random.nextInt(20); // 40 ~ 60
    bool? mixingTankIsNormal;
    mixingTankIsNormal = _getTemperatureStatus(temperature) == "보통" &&
        _getHumidityStatus(humidity) == "보통";

    // '작동' 상태라면 volume 값을 줄임
    if (isOperating) {
      _currentVolume =
          (_currentVolume - _dynamicDecreaseRate).clamp(0.0, 200.0); // 0 ~ 70 범위로 제한
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
      'volumeStatus': _getVolumnStatus(_currentVolume),
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

  String _getVolumnStatus(double volume) {
    if (volume < 20.0) {
      return "낮음";
    } else if (volume <= 200.0) {
      return "보통";
    } else {
      return "높음";
    }
  }
}
