import 'package:flutter/material.dart';

class FoodProcessorOffPage extends StatelessWidget {
  const FoodProcessorOffPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("미생물 음식물 처리기 - 꺼짐"),
      ),
      body: const Center(
        child: Text(
          "음식물 처리기가 꺼져 있습니다.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}