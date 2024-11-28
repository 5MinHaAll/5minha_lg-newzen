import 'package:flutter/material.dart';

class LabelResultScreen extends StatelessWidget {
  final Map<String, List<String>> categorizedLabels;

  const LabelResultScreen({required this.categorizedLabels, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("라벨링 결과"),
      ),
      body: ListView(
        children: [
          buildCategorySection("처리 가능", categorizedLabels["처리 가능"] ?? []),
          buildCategorySection("주의", categorizedLabels["주의"] ?? []),
          buildCategorySection("처리 불가능", categorizedLabels["처리 불가능"] ?? []),
        ],
      ),
    );
  }

  Widget buildCategorySection(String title, List<String> labels) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: labels.isEmpty
              ? [const Padding(padding: EdgeInsets.all(8), child: Text("항목 없음"))]
              : labels.map((label) => ListTile(title: Text(label))).toList(),
        ),
      ),
    );
  }
}
