import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'detection_result_page.dart';
import 'detect_screen.dart';

class TimeBoundDetectScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String model;

  const TimeBoundDetectScreen({
    super.key,
    required this.cameras,
    required this.model,
  });

  @override
  State<TimeBoundDetectScreen> createState() => _TimeBoundDetectScreenState();
}

class _TimeBoundDetectScreenState extends State<TimeBoundDetectScreen> {
  List<Map<String, dynamic>> detectedObjects = [];
  bool isCollecting = false;
  Timer? _timer;
  List<String> allowedLabels = ['apple','banana']; // 라벨 리스트를 저장할 변수
  List<String> food_labels = ["bread", "pancake", "waffle", "bagel", "muffin", "doughnut", "hamburger", "pizza", "sandwich", "hot dog", "french fries", "apple", "orange", "banana", "grape"];


  // @override
  // void initState() {
  //   super.initState();
  //   loadLabels('assets/food_labelmap.txt'); // 라벨 데이터를 초기화 시 로드
  // }
  //
  // Future<void> loadLabels(String filePath) async {
  //   try {
  //     final file = File(filePath);
  //     final contents = await file.readAsLines(); // 파일의 각 줄을 리스트로 읽기
  //     setState(() {
  //       allowedLabels = contents; // 읽어온 데이터를 상태에 저장
  //     });
  //   } catch (e) {
  //     print('Error loading labels: $e');
  //   }
  // }

  void startDetection() {
    setState(() {
      detectedObjects = [];
      isCollecting = true;
    });

    // 10초 후 수집 종료
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        isCollecting = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetectionResultPage(detectedObjects: detectedObjects),
        ),
      );
    });
  }

  void onRecognitions(List<dynamic> recognitions) {
    if (isCollecting) {
      setState(() {
        for (var recognition in recognitions) {
          final label = recognition['detectedClass'];
          final isProcessable = allowedLabels.contains(label); // 처리 가능 여부 확인

          if (food_labels.contains(label)) {
            detectedObjects.add({
              'label': recognition['detectedClass'],
              'confidence': (recognition['confidenceInClass'] * 100).toStringAsFixed(1),
              'processable': isProcessable ? '처리 가능' : '처리 불가능',
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Detection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: isCollecting ? null : startDetection,
          ),
        ],
      ),
      body: DetectScreen(
        cameras: widget.cameras,
        model: widget.model,
        onRecognitions: onRecognitions,
      ),
    );
  }
}
