import 'dart:ui';

class CameraSettings {
  // 카메라 프리뷰의 가로 세로 비율을 저장하는 변수
  static double? ratio;
  // 화면 크기를 저장하는 변수
  static Size? screenSize;
  // 입력 이미지 크기를 저장하는 변수
  static Size? inputImageSize;
  // 실제 프리뷰 크기를 계산하여 반환하는 getter
  static Size get actualPreviewSize => Size(
    // 화면의 너비
    screenSize?.width ?? 0,
    // 화면의 너비에 비율을 곱하여 높이를 계산
    (screenSize?.width ?? 0) * (ratio ?? 0),
  );
}