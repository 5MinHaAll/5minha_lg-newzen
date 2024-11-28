import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 초기화
  await Firebase.initializeApp();
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
