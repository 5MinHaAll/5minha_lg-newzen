// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_vision/flutter_vision.dart';
// import 'package:camera/camera.dart';
// import '../../theme/app_colors.dart';
//
// class YoloLiveScreen extends StatefulWidget {
//   const YoloLiveScreen({super.key});
//
//   @override
//   State<YoloLiveScreen> createState() => _YoloLiveScreenState();
// }
//
// class _YoloLiveScreenState extends State<YoloLiveScreen> {
//   late FlutterVision vision;
//   late List<CameraDescription> cameras;
//   CameraController? cameraController;
//   bool isLoaded = false;
//   bool isDetecting = false;
//   List<Map<String, dynamic>> yoloResults = [];
//
//   // 감지 관련 상태 추가
//   bool hasDetections = false;
//   Timer? noDetectionTimer;
//   bool showWarning = false;
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   Future<void> init() async {
//     cameras = await availableCameras();
//     vision = FlutterVision();
//     await vision.loadYoloModel(
//       labels: 'assets/models/food_waste_detect_label.txt',
//       modelPath: 'assets/models/food_waste_detect_yolo11.tflite',
//       modelVersion: "yolov8",
//       quantization: false,
//       numThreads: 2,
//       useGpu: true,
//     );
//
//     cameraController = CameraController(
//       cameras[0],
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     await cameraController?.initialize();
//     if (mounted) {
//       setState(() {
//         isLoaded = true;
//         startDetection();
//       });
//     }
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
//
//     if (mounted) {
//       setState(() {
//         yoloResults = result;
//         hasDetections = result.isNotEmpty;
//
//         // 감지 상태에 따른 타이머 처리
//         if (hasDetections) {
//           showWarning = false;
//           noDetectionTimer?.cancel();
//         } else {
//           // 감지되지 않은 경우 타이머 시작 또는 재설정
//           noDetectionTimer?.cancel();
//           noDetectionTimer = Timer(const Duration(seconds: 3), () {
//             if (mounted && !hasDetections) {
//               setState(() {
//                 showWarning = true;
//               });
//             }
//           });
//         }
//       });
//     }
//     isDetecting = false;
//   }
//
//   Future<void> startDetection() async {
//     if (cameraController != null) {
//       cameraController?.startImageStream((image) async {
//         if (!isDetecting) {
//           isDetecting = true;
//           yoloOnFrame(image);
//         }
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     vision.closeYoloModel();
//     cameraController?.dispose();
//     noDetectionTimer?.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!isLoaded) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     final Size size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // 카메라 프리뷰
//           CameraPreview(cameraController!),
//
//           // YOLO 감지 결과 표시
//           ...displayYOLODetectionOverlay(size),
//
//           // 경고 메시지 오버레이
//           if (showWarning)
//             Positioned(
//               top: 100,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.black87,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   '음식물이 감지되지 않았습니다.\n카메라를 음식물에 더 가까이 가져가보세요.',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> displayYOLODetectionOverlay(Size size) {
//     if (yoloResults.isEmpty) return [];
//
//     // 카메라 미리보기 크기 계산
//     final double previewRatio = size.width / size.height;
//     final double cameraRatio = cameraController!.value.aspectRatio;
//
//     late double factorX, factorY, paddingX, paddingY;
//
//     if (previewRatio > cameraRatio) {
//       // 세로가 긴 경우
//       factorX = size.width;
//       factorY = size.width * cameraRatio;
//       paddingX = 0;
//       paddingY = (size.height - factorY) / 2;
//     } else {
//       // 가로가 긴 경우
//       factorX = size.height * cameraRatio;
//       factorY = size.height;
//       paddingX = (size.width - factorX) / 2;
//       paddingY = 0;
//     }
//
//     return yoloResults.map((result) {
//       // 박스 색상 결정
//       final tag = result['tag'] as String;
//       Color boxColor;
//       if (yesFood.contains(tag)) {
//         boxColor = AppColors.success;
//       } else if (cautionFood.contains(tag)) {
//         boxColor = AppColors.warning;
//       } else {
//         boxColor = AppColors.error;
//       }
//
//       return Stack(
//         children: [
//           Positioned(
//             left: result["box"][0] * factorX + paddingX,
//             top: result["box"][1] * factorY + paddingY,
//             width: (result["box"][2] - result["box"][0]) * factorX,
//             height: (result["box"][3] - result["box"][1]) * factorY,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: boxColor, width: 2),
//               ),
//             ),
//           ),
//           Positioned(
//             left: result["box"][0] * factorX + paddingX,
//             top: result["box"][1] * factorY + paddingY - 20,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: Colors.black87,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }).toList();
//   }
// }
