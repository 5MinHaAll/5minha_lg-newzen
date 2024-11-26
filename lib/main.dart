import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'home.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(), // 최초 페이지를 Login으로 설정
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
    );
  }
}
