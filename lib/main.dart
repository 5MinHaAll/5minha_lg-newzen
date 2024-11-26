import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'home.dart';
import 'login.dart';

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
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Login(), // 최초 페이지를 Login으로 설정
//       debugShowCheckedModeBanner: false, // 디버그 배너 제거
//     );
//   }
// }

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
      initialRoute: '/', // 초기 경로 설정
      routes: {
        '/': (context) => const Login(), // 초기 화면(Login)
        '/home': (context) => const Home(
            title: 'Flutter Demo Home Page', userId: "text"), // Home 화면 경로 설정
      },
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
    );
  }
}
