// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vision/flutter_vision.dart';
//
// class YoloLiveScreen extends StatefulWidget {
//   const YoloLiveScreen({super.key});
//
//   @override
//   State<YoloLiveScreen> createState() => _YoloLiveScreenState();
// }
//
// class _YoloLiveScreenState extends State<YoloLiveScreen>
//     with WidgetsBindingObserver {
//   FlutterVision vision = FlutterVision();
//   late CameraController controller;
//   late List<Map<String, dynamic>> yoloResults;
//   CameraImage? cameraImage;
//   bool isLoaded = false;
//   bool isDetecting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   Future<void> init() async {
//     var cameras = await availableCameras();
//     controller = CameraController(cameras.first, ResolutionPreset.high,
//         imageFormatGroup: ImageFormatGroup.yuv420);
//     controller.initialize().then((value) {
//       loadYoloModel().then((value) {
//         setState(() {
//           isLoaded = true;
//           isDetecting = false;
//           yoloResults = [];
//         });
//       });
//     });
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     if (!isLoaded) {
//       return const Scaffold(
//         body: Center(
//           child: Text("Model not loaded, waiting for it"),
//         ),
//       );
//     }
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: CameraPreview(
//             controller,
//           ),
//         ),
//         ...displayBoxesAroundRecognizedObjects(size),
//         Positioned(
//           bottom: 75,
//           width: MediaQuery.of(context).size.width,
//           child: Container(
//             height: 80,
//             width: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                   width: 5, color: Colors.white, style: BorderStyle.solid),
//             ),
//             child: isDetecting
//                 ? IconButton(
//                     onPressed: () async {
//                       stopDetection();
//                     },
//                     icon: const Icon(
//                       Icons.stop,
//                       color: Colors.red,
//                     ),
//                     iconSize: 50,
//                   )
//                 : IconButton(
//                     onPressed: () async {
//                       await startDetection();
//                     },
//                     icon: const Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                     ),
//                     iconSize: 50,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> loadYoloModel() async {
//     await vision.loadYoloModel(
//         labels: 'assets/models/food_waste_detect_label.txt',
//         modelPath: 'assets/models/food_waste_detect_yolo11.tflite',
//         modelVersion: "yolov8",
//         numThreads: 2,
//         useGpu: true);
//     setState(() {
//       isLoaded = true;
//     });
//   }
//
//   Future<void> yoloOnFrame(CameraImage cameraImage) async {
//     final result = await vision.yoloOnFrame(
//       bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
//       imageHeight: cameraImage.height,
//       imageWidth: cameraImage.width,
//       iouThreshold: 0.8,
//       confThreshold: 0.4,
//       classThreshold: 0.5,
//     );
//     if (result.isNotEmpty) {
//       setState(() {
//         yoloResults = result;
//       });
//     }
//   }
//
//   Future<void> startDetection() async {
//     setState(() {
//       isDetecting = true;
//     });
//     if (controller.value.isStreamingImages) {
//       return;
//     }
//     await controller.startImageStream((image) async {
//       if (isDetecting) {
//         cameraImage = image;
//         yoloOnFrame(image);
//       }
//     });
//   }
//
//   Future<void> stopDetection() async {
//     setState(() {
//       isDetecting = false;
//       yoloResults.clear();
//     });
//   }
//
//   List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
//     if (yoloResults.isEmpty) return [];
//     double factorX = screen.width / (cameraImage?.height ?? 1);
//     double factorY = screen.height / (cameraImage?.width ?? 1);
//
//     Color colorPick = const Color.fromARGB(255, 50, 233, 30);
//
//     return yoloResults.map((result) {
//       return Positioned(
//         left: result["box"][0] * factorX,
//         top: result["box"][1] * factorY,
//         width: (result["box"][2] - result["box"][0]) * factorX,
//         height: (result["box"][3] - result["box"][1]) * factorY,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//             border: Border.all(color: Colors.pink, width: 2.0),
//           ),
//           child: Text(
//             "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
//             style: TextStyle(
//               background: Paint()..color = colorPick,
//               color: Colors.white,
//               fontSize: 18.0,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }
// }



import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';

import 'label_result_screen.dart';

class YoloLiveScreen extends StatefulWidget {
  const YoloLiveScreen({super.key});

  @override
  State<YoloLiveScreen> createState() => _YoloLiveScreenState();
}

class _YoloLiveScreenState extends State<YoloLiveScreen>
    with WidgetsBindingObserver {
  FlutterVision vision = FlutterVision();
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;

  // 라벨링 기준
  final List<String> processable = [
    "Apple",
    "Banana",
    "Bread",
    "Bun",
    "Chicken-skin",
    "Congee",
    "Cucumber",
    "Orange",
    "Pear",
    "Pear-peel",
    "Tomato",
    "Vegetable",
    "Vegetable-root",
    "Fish",
    "Meat",
    "Egg-hard",
    "Egg-scramble",
    "Egg-steam",
    "Egg-yolk",
    "Tofu",
    "Rice",
    "Noodle",
    "Pasta",
    "Mushroom",
    "Pancake",
  ];

  final List<String> caution = [
    "Apple-core",
    "Banana-peel",
    "Orange-peel",
    "Potato",
    "Shrimp",
    "High-fiber Vegetables",
  ];

  final List<String> nonProcessable = [
    "Bone",
    "Bone-fish",
    "Mussel-shell",
    "Egg-shell",
    "Shrimp-shell",
    "Drink",
    "Other-waste",
  ];

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
    controller = CameraController(cameras.first, ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/models/food_waste_detect_label.txt',
        modelPath: 'assets/models/food_waste_detect_yolo11.tflite',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
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

  // 라벨 분류 함수
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
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  void navigateToResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LabelResultScreen(
          categorizedLabels: categorizedLabels,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
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
        ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isDetecting ? stopDetection : startDetection,
                child: Text(isDetecting ? "Stop Detection" : "Start Detection"),
              ),
              ElevatedButton(
                onPressed: navigateToResultPage,
                child: const Text("라벨링 결과 보기"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              backgroundColor: Colors.black54,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
