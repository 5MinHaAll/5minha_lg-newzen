import 'dart:async';
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
          detectedObjects.add({
            'label': recognition['detectedClass'],
            'confidence': (recognition['confidenceInClass'] * 100).toStringAsFixed(1),
          });
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
