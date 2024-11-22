// import 'package:flutter/material.dart';
// import 'package:newzen/theme/app_colors.dart';
// import 'package:newzen/theme/app_text.dart';
// import 'login.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'LG ThinQ',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.light(
//           primary: AppColors.primary,
//           onPrimary: Colors.white,
//           secondary: AppColors.secondary,
//           onSecondary: Colors.white,
//           background: AppColors.primaryBackground,
//           onBackground: AppColors.primaryText,
//           surface: AppColors.secondaryBackground,
//           onSurface: AppColors.primaryText,
//           error: AppColors.error,
//           onError: Colors.white,
//         ),
//         textTheme: AppTypography.getTextTheme(),
//         scaffoldBackgroundColor: AppColors.primaryBackground,
//         appBarTheme: AppBarTheme(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//         ),
//       ),
//       home: const Login(), // 최초 페이지를 Login으로 설정
//       debugShowCheckedModeBanner: false, // 디버그 배너 제거
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LG ThinQ',
      theme: AppTheme.lightTheme,
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}