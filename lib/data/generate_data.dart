import 'dart:math';

class RandomDataService {
  final Random _random = Random();

  double _currentVolume = 70.0; // 초기 용량
  final double _decreaseRate = 0.1; // 감소 속도 (한 번 호출 시 줄어드는 값)

  Map<String, dynamic> generatePottingSoilData() {
    final int temperature = 35 + _random.nextInt(20); // 35 ~ 55
    final int humidity = 40 + _random.nextInt(20); // 40 ~ 60
    final double rawPh = 6.4 + _random.nextDouble() * 2.1; // 6.5 ~ 8.5
    final double ph = (rawPh * 10).ceilToDouble() / 10;


    return {
      'timestamp': DateTime.now().toIso8601String(), // 현재 시간
      'temperature': temperature,
      'temperatureStatus': _getTemperatureStatus(temperature),
      'humidity': humidity,
      'humidityStatus': _getHumidityStatus(humidity),
      'ph': ph,
      'phStatus': _getPhStatus(ph),
    };
  }

  Map<String, dynamic> generateMixingTankData({bool isRunning = false}) {
    final int temperature = 35 + _random.nextInt(20); // 35 ~ 55
    final int humidity = 40 + _random.nextInt(20); // 40 ~ 60
    // '작동' 상태라면 volume 값을 줄임
    if (isRunning) {
      _currentVolume = (_currentVolume - _decreaseRate).clamp(0.0, 70.0); // 0 ~ 70 범위로 제한
    }

    return {
      'timestamp': DateTime.now().toIso8601String(), // 현재 시간
      'temperature': temperature,
      'temperatureStatus': _getTemperatureStatus(temperature),
      'humidity': humidity,
      'humidityStatus': _getHumidityStatus(humidity),
      'volume': _currentVolume,
      'volumeStatus': _getVolumnStatus(_currentVolume),
    };
  }

  String _getTemperatureStatus(int temperature) {
    if (temperature < 40) {
      return "낮음";
    } else if (temperature <= 50) {
      return "보통";
    } else {
      return "높음";
    }
  }

  String _getHumidityStatus(int humidity) {
    if (humidity < 45) {
      return "낮음";
    } else if (humidity <= 55) {
      return "보통";
    } else {
      return "높음";
    }
  }

  String _getPhStatus(double ph) {
    if (ph < 7.0) {
      return "낮음";
    } else if (ph <= 8.0) {
      return "보통";
    } else {
      return "높음";
    }
  }

  String _getVolumnStatus(double volume) {
    if (volume < 20.0) {
      return "낮음";
    } else if (volume <= 80.0) {
      return "보통";
    } else {
      return "높음";
    }
  }

}

