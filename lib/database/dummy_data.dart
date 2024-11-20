import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

class RandomDataGenerator extends StatefulWidget {
  @override
  _RandomDataGeneratorState createState() => _RandomDataGeneratorState();
}

class _RandomDataGeneratorState extends State<RandomDataGenerator> {
  // late DatabaseReference _dbRef;
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // _dbRef = FirebaseDatabase.instance.ref('random_data'); // 데이터 저장 위치 지정
    startGeneratingData(); // 데이터 생성 시작
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 종료
    super.dispose();
  }

  void startGeneratingData() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // 5초마다 실행
      generateAndStoreRandomData();
    });
  }

  Future<void> generateAndStoreRandomData() async {
    // 무작위 데이터 생성
    final randomData = {
      'timestamp': DateTime.now().toIso8601String(), // 현재 시간
      'value': _random.nextInt(100), // 0~99 범위의 정수
    };

    // try {
    //   // Firebase에 데이터 저장
    //   await _dbRef.push().set(randomData);
    //   print("Data added: $randomData");
    // } catch (e) {
    //   print("Error adding data: $e");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Data Generator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Generating random data...",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                generateAndStoreRandomData(); // 버튼을 눌러 즉시 데이터 생성
              },
              child: const Text("Generate Now"),
            ),
          ],
        ),
      ),
    );
  }
}
