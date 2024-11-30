import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import '../../components/appbar_default.dart';
import 'detection_label.dart';
import 'dialog_helper.dart';

class DetectionResultScreen extends StatefulWidget {
  final String imagePath;

  const DetectionResultScreen({required this.imagePath, super.key});

  @override
  State<DetectionResultScreen> createState() => _DetectionResultScreenState();
}

class _DetectionResultScreenState extends State<DetectionResultScreen> {
  FlutterVision vision = FlutterVision();
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool yoloModelLoaded = false;
  List<Map<String, dynamic>> yoloResults = [];
  Map<String, List<String>> categorizedLabels = {
    "처리 가능": [],
    "주의": [],
    "처리 불가능": [],
  };

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.imagePath);
    _loadYoloModel().then((_) {
      if (yoloModelLoaded) {
        _runYoloOnImage();
      }
    });
  }

  Future<void> _loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/models/food_waste_detect_label.txt',
      modelPath: 'assets/models/food_waste_detect_yolo11.tflite',
      modelVersion: "yolov8",
      quantization: false,
      numThreads: 2,
      useGpu: true,
    );
    setState(() {
      yoloModelLoaded = true;
    });
  }

  Future<void> _runYoloOnImage() async {
    if (imageFile == null) return;

    Uint8List bytes = await imageFile!.readAsBytes();
    final image = await decodeImageFromList(bytes);
    final results = await vision.yoloOnImage(
      bytesList: bytes,
      imageHeight: image.height,
      imageWidth: image.width,
      iouThreshold: 0.8,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    if (results.isNotEmpty) {
      setState(() {
        imageHeight = image.height;
        imageWidth = image.width;
        yoloResults = results;
        _categorizeLabels();
      });
    }
  }

  void _categorizeLabels() {
    categorizedLabels = {
      "처리 가능": [],
      "주의": [],
      "처리 불가능": [],
    };

    final List<String> processable = yesFood;
    final List<String> caution = cautionFood;
    final List<String> nonProcessable = noFood;

    for (var result in yoloResults) {
      final tag = result['tag'];
      if (processable.contains(tag)) {
        categorizedLabels["처리 가능"]?.add(tag);
      } else if (caution.contains(tag)) {
        categorizedLabels["주의"]?.add(tag);
      } else if (nonProcessable.contains(tag)) {
        categorizedLabels["처리 불가능"]?.add(tag);
      }
    }
  }

  List<Widget> displayYOLODetectionOverImage(Size screen) {
    final List<String> processable = yesFood;
    final List<String> caution = cautionFood;

    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (imageWidth);
    double imgRatio = imageWidth / imageHeight;
    double newWidth = imageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (imageHeight);

    // Fix padding for centered alignment
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = kToolbarHeight;
    double availableHeight = screen.height - statusBarHeight - appBarHeight;
    double paddingY = (availableHeight - newHeight) / 2;

    return yoloResults.map((result) {
      Color boxColor;
      if (processable.contains(result['tag'])) {
        boxColor = Colors.greenAccent;
      } else if (caution.contains(result['tag'])) {
        boxColor = Colors.orangeAccent;
      } else {
        boxColor = Colors.redAccent;
      }

      return Stack(
        children: [
          // 네모 박스
          Positioned(
            left: result["box"][0] * factorX,
            top: result["box"][1] * factorY + paddingY,
            width: (result["box"][2] - result["box"][0]) * factorX,
            height: (result["box"][3] - result["box"][1]) * factorY,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: boxColor, width: 2.0),
              ),
            ),
          ),
          // 텍스트 (좌측 상단)
          Positioned(
            left: result["box"][0] * factorX,
            top: result["box"][1] * factorY + paddingY - 20, // 박스 위로 약간 이동
            child: Text(
              "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                backgroundColor: Colors.black54,
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: DefaultAppBar(
        title: "스캔 결과",
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageFile != null
                ? Image.file(imageFile!)
                : const Center(child: Text("이미지를 로드할 수 없습니다.")),
            ...displayYOLODetectionOverImage(size),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  showLabelResultDialog(
                    context,
                    categorizedLabels, // 전달할 라벨 데이터
                  );
                },
                child: const Text("스캔 결과 확인하기"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
