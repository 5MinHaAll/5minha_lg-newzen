import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newzen/features/detection/detection_label.dart';
import 'package:newzen/features/detection/waste_categories.dart';
import '../../theme/app_text.dart';
import 'detection_result_screen.dart';
import 'dialog_helper.dart';

class YoloLiveScreen extends StatefulWidget {
  const YoloLiveScreen({super.key});

  @override
  State<YoloLiveScreen> createState() => _YoloLiveScreenState();
}

class _YoloLiveScreenState extends State<YoloLiveScreen> {
  FlutterVision vision = FlutterVision();
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  bool _isFlashOn = false;

  final List<String> processable = yesFood;
  final List<String> caution = cautionFood;
  final List<String> nonProcessable = noFood;

  // 분류 결과 저장
  Map<String, List<String>> categorizedLabels = {
    "처리 가능": [],
    "주의": [],
    "처리 불가능": [],
  };

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    var cameras = await availableCameras();
    controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await controller.initialize();
    await loadYoloModel();
    setState(() {
      isLoaded = true;
      yoloResults = [];
    });
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/models/food_waste_detect_label.txt',
      modelPath: 'assets/models/food_waste_detect_yolo11.tflite',
      modelVersion: "yolov8",
      numThreads: 2,
      useGpu: true,
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetectionResultScreen(imagePath: pickedFile.path),
        ),
      );
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        await yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    await controller.stopImageStream();
    setState(() {
      isDetecting = false;
      yoloResults.clear();
      cameraImage = null;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.8,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
        categorizeLabels();
      });
    }
  }

  void categorizeLabels() {
    categorizedLabels = {
      "처리 가능": [],
      "주의": [],
      "처리 불가능": [],
    };

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

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    return yoloResults.map((result) {
      Color boxColor;
      if (processable.contains(result['tag'])) {
        boxColor = Colors.greenAccent;
      } else if (caution.contains(result['tag'])) {
        boxColor = Colors.orangeAccent;
      } else {
        boxColor = Colors.redAccent;
      }
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: boxColor, width: 2.0),
          ),
          child: Text(
            // "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            "${getNameKo(result['tag']) ?? 'Unknown'} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            // style: const TextStyle(
            //   backgroundColor: Colors.black54,
            //   color: Colors.white,
            //   fontSize: 18.0,
            // ),
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              backgroundColor: Colors.black54,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _toggleFlash() async {
    if (controller == null || !controller!.value.isInitialized) return;

    // 플래시 상태를 토글
    _isFlashOn = !_isFlashOn;
    await controller!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          // child: Text("Model not loaded, waiting for it"),
          child: CircularProgressIndicator(), // 로딩 애니메이션
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
        if (yoloResults.isNotEmpty)
          ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          top: 50, // 화면 상단에서의 거리
          left: 30, // 화면 왼쪽에서의 거리
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // 뒤로 가기 동작
            },
            child: Container(
              padding: const EdgeInsets.all(10), // 클릭 영역 확장
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // 반투명 배경
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back, // 뒤로 가기 아이콘
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            color: Colors.black.withOpacity(0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _toggleFlash,
                  icon: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (isDetecting) {
                      await stopDetection(); // 탐지를 멈추고
                      showLabelResultDialog(
                          context, categorizedLabels); // 라벨링 결과 다이얼로그 표시
                    } else {
                      startDetection(); // 탐지 시작
                    }
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 4),
                    ),
                    child: Icon(
                      isDetecting ? Icons.stop : Icons.camera,
                      size: 35,
                      color: isDetecting ? Colors.red : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
