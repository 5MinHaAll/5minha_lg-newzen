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

      if (!wasteCategories.containsKey("guidelines")) {
        return const SizedBox.shrink();
      }

      final Map<String, dynamic> guidelinesMap =
          Map<String, dynamic>.from(wasteCategories["guidelines"] as Map);

      if (!guidelinesMap.containsKey(categoryKey)) {
        return const SizedBox.shrink();
      }

      final Map<String, dynamic> guidelines =
          Map<String, dynamic>.from(guidelinesMap[categoryKey] as Map);

      final List<String> details =
          List<String>.from(guidelines["details"] as List? ?? []);

      final List<String> examples =
          List<String>.from(guidelines["examples"] as List? ?? []);

      final String title = guidelines["title"] as String? ?? "상세 정보";
      final String subtitle = guidelines["subtitle"] as String? ?? "";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: category == "처리 가능"
                      ? Colors.green
                      : category == "주의"
                          ? Colors.orange
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          if (details.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              "주의사항",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...details.map(
              (detail) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "• $detail",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
          if (examples.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              "예시",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...examples.map(
              (example) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "• $example",
                  style: Theme.of(context).textTheme.bodyMedium,
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

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/info/food/$foodName.png',
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.fastfood,
                                color: Colors.grey, size: 30),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              koreanName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: category == "처리 가능"
                                        ? Colors.green
                                        : category == "주의"
                                            ? Colors.orange
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDetailContent(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
