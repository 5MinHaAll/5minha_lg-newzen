import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:untitled/services/recognition.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';

class Classifier {
  // 인터프리터 및 레이블 저장
  Interpreter? _interpreter;
  List<String>? _labels;
  // 모델 및 레이블 파일 이름, 입력 크기, 임계값 정의
  static const String MODEL_FILE_NAME = "detect.tflite";
  static const String LABEL_FILE_NAME = "labelmap.txt";
  static const int INPUT_SIZE = 300;
  static const double THRESHOLD = 0.5;
  ImageProcessor? imageProcessor;
  int? padSize;
  List<List<int>>? _outputShapes;
  List<TfLiteType>? _outputTypes;
  static const int NUM_RESULTS = 10;
  // Classifier 클래스 생성자
  Classifier({
    Interpreter? interpreter,
    List<String>? labels,
  }) {
    loadModel(interpreter: interpreter);
    loadLabels(labels: labels);
  }
  // 머신러닝 모델 로드
  void loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            MODEL_FILE_NAME,
            options: InterpreterOptions()..threads = 4,
          );
      var outputTensors = _interpreter?.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      outputTensors?.forEach((tensor) {
        _outputShapes?.add(tensor.shape);
        _outputTypes?.add(tensor.type as TfLiteType);
      });
    } catch (e) {
      print(e);
    }
  }
  // 레이블 로드
  void loadLabels({List<String>? labels}) async {
    try {
      _labels =
          labels ?? await FileUtil.loadLabels("assets/" + LABEL_FILE_NAME);
    } catch (e) {
      print(e);
    }
  }
  // 입력 이미지를 처리
  TensorImage getProcessedImage(TensorImage? inputImage) {
    padSize = max(inputImage?.height ?? 0, inputImage?.width ?? 0);

    imageProcessor ??= ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(padSize ?? 0, padSize ?? 0))
        .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
        .build();
    inputImage = imageProcessor?.process(inputImage!);
    return inputImage!;
  }
  // 이미지를 예측하고 인식 결과를 반환
  Map<String, dynamic>? predict(imageLib.Image image) {
    if (_interpreter == null) {
      return null;
    }
    // 입력 이미지를 처리하고 예측
    TensorImage inputImage = TensorImage.fromImage(image);
    inputImage = getProcessedImage(inputImage);
    // 각 출력 텐서를 저장할 TensorBuffer 정의
    TensorBuffer outputLocations = TensorBufferFloat(_outputShapes![0]);
    TensorBuffer outputClasses = TensorBufferFloat(_outputShapes![1]);
    TensorBuffer outputScores = TensorBufferFloat(_outputShapes![2]);
    TensorBuffer numLocations = TensorBufferFloat(_outputShapes![3]);
    // 입력 이미지
    List<Object> inputs = [inputImage.buffer];
    // 출력에 해당하는 텐서 버퍼를 저장할 Map 정의
    Map<int, Object> outputs = {
      0: outputLocations.buffer,
      1: outputClasses.buffer,
      2: outputScores.buffer,
      3: numLocations.buffer,
    };
    // 머신러닝 모델 실행
    _interpreter?.runForMultipleInputs(inputs, outputs);
    int resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));
    int labelOffset = 1;
    // 인식된 객체의 위치 변환
    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [1, 0, 3, 2],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );
    // 인식 결과를 저장할 목록 정의
    List<Recognition> recognitions = [];
    // 각 인식 결과를 Recognition 객체로 생성하고 목록에 추가
    for (int i = 0; i < resultsCount; i++) {
      var score = outputScores.getDoubleValue(i);
      var labelIndex = outputClasses.getIntValue(i) + labelOffset;
      var label = _labels?.elementAt(labelIndex);
      if (score > THRESHOLD) {
        Rect? transformedRect = imageProcessor?.inverseTransformRect(
          locations[i],
          image.height,
          image.width,
        );

        recognitions.add(
          Recognition(i, label, score, transformedRect),
        );
      }
    }
    // 인식 결과 반환
    return {
      "recognitions": recognitions,
    };
  }
  // 인터프리터 및 레이블 getter
  Interpreter? get interpreter => _interpreter;
  List<String>? get labels => _labels;
}