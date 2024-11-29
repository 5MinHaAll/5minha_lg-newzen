import 'package:flutter/material.dart';
import 'food_detail.dart';
import 'waste_categories.dart';

class DialogFullscreen extends StatelessWidget {
  final Map<String, List<String>> labels;

  const DialogFullscreen({
    required this.labels,
    super.key,
  });

  String _getCategoryKey(String category) {
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

  Map<String, dynamic> _getFoodInfo(String foodName, String category) {
    try {
      final categoryKey = _getCategoryKey(category);
      final List<Map<String, dynamic>> categoryList =
          List<Map<String, dynamic>>.from(
              (wasteCategories[categoryKey] as List<dynamic>).map((item) =>
                  Map<String, dynamic>.from(item as Map<String, dynamic>)));

      // Drink인 경우 특별 처리
      if (foodName == "Drink") {
        return {
          "name": foodName,
          "name_ko": "음료/국물",
          "category": "액체류",
          "  ": category,
        };
      }

      return categoryList.firstWhere(
        (food) => food["name"] == foodName,
        orElse: () => {
          "name": foodName,
          "name_ko": foodName,
          "category": categoryKey == "processable"
              ? "처리 가능"
              : categoryKey == "caution"
                  ? "주의 필요"
                  : "처리 불가",
          "status": category,
        },
      );
    } catch (e) {
      debugPrint('Error in _getFoodInfo: $e');
      return {
        "name": foodName,
        "name_ko": foodName,
        "category": "기타",
        "status": category,
      };
    }
  }

  Widget _buildFoodItem(
      BuildContext context, String foodName, String category) {
    final foodInfo = _getFoodInfo(foodName, category);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Image.asset(
          'assets/images/info/food/$foodName.png',
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, color: Colors.grey),
            );
          },
        ),
        title: Text(
          foodInfo["name_ko"] as String,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          category,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: category == "처리 가능"
                    ? Colors.green
                    : category == "주의"
                        ? Colors.orange
                        : Colors.red,
              ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => FoodDetail(
              foodName: foodName,
              category: category,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          '음식 스캔 결과',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final category = labels.keys.elementAt(index);
          final foodList = labels[category]?.toSet().toList() ?? [];

          if (foodList.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: category == "처리 가능"
                            ? Colors.green
                            : category == "주의"
                                ? Colors.orange
                                : Colors.red,
                      ),
                ),
              ),
              ...foodList
                  .map(
                      (foodName) => _buildFoodItem(context, foodName, category))
                  .toList(),
            ],
          );
        },
      ),
    );
  }
}
