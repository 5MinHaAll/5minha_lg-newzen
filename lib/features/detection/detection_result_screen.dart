import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:newzen/theme/app_text.dart';
import '../../components/appbar_default.dart';
import '../../theme/app_colors.dart';
import 'detection_label.dart';
import 'dialog_helper.dart';
import 'waste_categories.dart';

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
  bool isLoading = true; // 로딩 상태 추가
  bool hasDetections = false; // 감지 결과 유무 상태 추가
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
    try {
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('모델 로드 실패', '음식물 인식 모델을 불러오는데 실패했습니다.');
    }
  }

  Future<void> _runYoloOnImage() async {
    if (imageFile == null) return;

    try {
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

      setState(() {
        imageHeight = image.height;
        imageWidth = image.width;
        yoloResults = results;
        hasDetections = results.isNotEmpty;
        isLoading = false;
        if (hasDetections) {
          _categorizeLabels();
        }
      });

      if (!hasDetections) {
        _showErrorDialog(
          '음식물 미감지',
          '이미지에서 음식물을 찾을 수 없습니다.\n다른 이미지로 다시 시도해주세요.',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('이미지 처리 실패', '이미지 분석 중 오류가 발생했습니다.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                // 오류 상황에서 이전 화면으로 돌아가기
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  String? getNameKo(String tag) {
    final categories = ['processable', 'caution', 'nonProcessable'];

    for (var category in categories) {
      final items = wasteCategories[category];
      if (items is List<Map<String, dynamic>>) {
        for (var item in items) {
          if (item['name'] == tag) {
            return item['name_ko'];
          }
        }
      }
    }
    return null;
  }

  List<Widget> displayYOLODetectionOverImage(Size screen) {
    if (!hasDetections) return [];
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
        boxColor = AppColors.success;
      } else if (caution.contains(result['tag'])) {
        boxColor = AppColors.warning;
      } else {
        boxColor = AppColors.error;
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
              // "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
              "${getNameKo(result['tag']) ?? 'Unknown'} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
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
            if (imageFile != null)
              Image.file(imageFile!)
            else
              const Center(child: Text("이미지를 로드할 수 없습니다.")),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else ...[
              ...displayYOLODetectionOverImage(size),
              if (hasDetections)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      showLabelResultDialog(
                        context,
                        categorizedLabels,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "음식물 분류 확인하기",
                      style: AppTypography.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
