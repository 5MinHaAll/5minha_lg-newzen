import 'package:flutter/material.dart';
import 'waste_categories.dart';

class FoodDetail extends StatelessWidget {
  final String foodName;
  final String category;

  const FoodDetail({
    required this.foodName,
    required this.category,
    super.key,
  });

  String _getCategoryKey() {
    switch (category) {
      case "처리 가능":
        return "processable";
      case "주의":
        return "caution";
      case "처리 불가능":
        return "nonProcessable";
      default:
        return "processable";
    }
  }

  Map<String, dynamic>? _getFoodInfo() {
    try {
      final categoryKey = _getCategoryKey();
      if (!wasteCategories.containsKey(categoryKey)) {
        return {"name": foodName, "name_ko": foodName, "status": category};
      }

      if (foodName == "Drink") {
        return {
          "name": foodName,
          "name_ko": "음료/국물",
          "category": "액체류",
          "status": category,
          "details": "국물이나 음료는 소량씩 천천히 투입하세요."
        };
      }

      final categoryList = List<Map<String, dynamic>>.from(
          (wasteCategories[categoryKey] as List)
              .map((item) => Map<String, dynamic>.from(item as Map)));

      return categoryList.firstWhere(
        (food) => food["name"] == foodName,
        orElse: () =>
            {"name": foodName, "name_ko": foodName, "status": category},
      );
    } catch (e) {
      debugPrint('Error in _getFoodInfo: $e');
      return {"name": foodName, "name_ko": foodName, "status": category};
    }
  }

  Widget _buildDetailContent(BuildContext context) {
    try {
      final categoryKey = _getCategoryKey();
      final foodInfo = _getFoodInfo();

      // 가이드라인 정보 가져오기
      final guidelines = wasteCategories['guidelines'];
      if (guidelines == null) return const SizedBox.shrink();

      final Map<String, dynamic>? categoryGuidelines = (guidelines
          as Map<String, dynamic>)[categoryKey] as Map<String, dynamic>?;
      if (categoryGuidelines == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 음식 분류 정보
          Text(
            "분류",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            foodInfo?["category"] ?? "기타",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),

          // 2. 음식별 상세 설명
          if (foodInfo?["details"] != null) ...[
            Text(
              "처리 방법",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "• ${foodInfo?["details"]}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
          ],

          // 3. 카테고리별 가이드라인 제목과 부제목
          Text(
            categoryGuidelines['title'] as String? ?? "상세 정보",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: category == "처리 가능"
                      ? Colors.green
                      : category == "주의"
                          ? Colors.orange
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            categoryGuidelines['subtitle'] as String? ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),

          // 4. 주의사항
          if ((categoryGuidelines['details'] as List?)?.isNotEmpty ??
              false) ...[
            const SizedBox(height: 16),
            Text(
              "주의사항",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...(categoryGuidelines['details'] as List).map(
              (detail) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "• $detail",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ],
      );
    } catch (e) {
      debugPrint('Error in _buildDetailContent: $e');
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodInfo = _getFoodInfo();
    final koreanName = foodInfo?["name_ko"] ?? foodName;

    final guidelines = wasteCategories['guidelines'];
    final categoryKey = _getCategoryKey();
    final categoryGuidelines = guidelines != null
        ? (guidelines as Map<String, dynamic>)[categoryKey]
            as Map<String, dynamic>?
        : null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "상세 정보",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // 흰색 배경의 컨테이너
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          koreanName,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          foodInfo?["category"] ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/info/food/$foodName.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.fastfood,
                                  size: 60,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          categoryGuidelines?['title'] as String? ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: category == "처리 가능"
                                        ? Colors.green
                                        : category == "주의"
                                            ? Colors.orange
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categoryGuidelines?['subtitle'] as String? ?? "",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Details 부분만 좌측 정렬을 위해 Container로 감싸기
                        if ((categoryGuidelines?['details'] as List?)
                                ?.isNotEmpty ??
                            false)
                          Container(
                            width: double.infinity, // 전체 너비를 사용
                            alignment: Alignment.centerLeft, // 내부 콘텐츠를 좌측 정렬
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Column 내부 항목들을 좌측 정렬
                              children: [
                                ...(categoryGuidelines!['details'] as List).map(
                                  (detail) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      "$detail",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xFF0096AA),
                                          ),
                                      textAlign:
                                          TextAlign.left, // 텍스트 자체도 좌측 정렬
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
