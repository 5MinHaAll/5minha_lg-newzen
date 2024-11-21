import 'package:flutter/material.dart';

class DetectionResultPage extends StatelessWidget {
  final List<Map<String, dynamic>> detectedObjects;

  const DetectionResultPage({super.key, required this.detectedObjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Results'),
      ),
      body: detectedObjects.isEmpty
          ? const Center(child: Text('No objects detected.'))
          : ListView.builder(
        itemCount: detectedObjects.length,
        itemBuilder: (context, index) {
          final object = detectedObjects[index];
          return ListTile(
            title: Text('Object: ${object['label']}'),
            subtitle: Text('Confidence: ${object['confidence']}%'),
          );
        },
      ),
    );
  }
}
