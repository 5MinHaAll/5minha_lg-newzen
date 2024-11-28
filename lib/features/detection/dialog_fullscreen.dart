import 'package:flutter/material.dart';

class LabelResultScreenDialog extends StatelessWidget {
  final Map<String, List<String>> categorizedLabels;

  const LabelResultScreenDialog({required this.categorizedLabels, super.key});

  @override
  Widget build(BuildContext context) {
    // 중복 제거 로직
    final deduplicatedLabels = {
      for (var entry in categorizedLabels.entries)
        entry.key: entry.value.toSet().toList(),
    };

    return Dialog(
      insetPadding: EdgeInsets.zero, // Fullscreen으로 만들기 위해 패딩 제거
      child: Scaffold(
        appBar: AppBar(
          title: const Text("라벨링 결과"),
          automaticallyImplyLeading: false, // 뒤로가기 버튼 비활성화
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context), // 다이얼로그 닫기
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        body: ListView(
          children: [
            buildCategorySection("처리 가능", deduplicatedLabels["처리 가능"] ?? []),
            buildCategorySection("주의", deduplicatedLabels["주의"] ?? []),
            buildCategorySection("처리 불가능", deduplicatedLabels["처리 불가능"] ?? []),
          ],
        ),
      ),
    );
  }

  Widget buildCategorySection(String title, List<String> labels) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(thickness: 1.0),
            if (labels.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("항목 없음"),
              )
            else
              ...labels.map((label) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: ListTile(
                  title: Text(label),
                ),
              )),
          ],
        ),
      ),
    );
  }

}

void showLabelResultDialog(BuildContext context, Map<String, List<String>> categorizedLabels) {
  showDialog(
    context: context,
    builder: (context) => LabelResultScreenDialog(categorizedLabels: categorizedLabels),
    barrierDismissible: true, // 외부 탭으로 다이얼로그 닫기 가능
  );
}
