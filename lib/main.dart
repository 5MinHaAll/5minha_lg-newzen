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
    );
  }
}
