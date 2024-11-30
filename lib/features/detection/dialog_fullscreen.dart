import 'package:flutter/material.dart';
import '../../components/appbar_default.dart';
import '../../theme/app_colors.dart';
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

      if (foodName == "Drink") {
        return {
          "name": foodName,
          "name_ko": "음료/국물",
          "category": "액체류",
          "status": category,
          "imgNumber": "32"
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
          "imgNumber": "00"
        },
      );
    } catch (e) {
      debugPrint('Error in _getFoodInfo: $e');
      return {
        "name": foodName,
        "name_ko": foodName,
        "category": "기타",
        "status": category,
        "imgNumber": "00"
      };
    }
  }

  Widget _buildFoodItemGroup(
      BuildContext context, List<String> foodList, String category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: foodList.asMap().entries.map((entry) {
          final int idx = entry.key;
          final String foodName = entry.value;
          final bool isLast = idx == foodList.length - 1;

          return Column(
            children: [
              _buildFoodItemContent(context, foodName, category),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFCAD0DC),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFoodItemContent(
      BuildContext context, String foodName, String category) {
    final foodInfo = _getFoodInfo(foodName, category);

    String _getImagePath(Map<String, dynamic> foodInfo) {
      final imgNumber = foodInfo['imgNumber'] as String?;
      final name = foodInfo['name'] as String?;

      if (imgNumber == null || name == null) {
        return '';
      }

      final fileName = name.toLowerCase();
      final number = imgNumber.padLeft(2, '0');
      return 'assets/images/functions/info_food/$number-$fileName.png';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
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
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              _getImagePath(foodInfo),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[100],
                  child:
                      const Icon(Icons.fastfood, color: Colors.grey, size: 20),
                );
              },
            ),
          ),
          title: Text(
            foodInfo["name_ko"] as String,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.tertiary,
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "처리 가능":
        return AppColors.success;
      case "주의":
        return AppColors.warning;
      case "처리 불가능":
        return AppColors.error;
      default:
        return AppColors.primaryText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedLabels = Map.fromEntries(
      labels.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: DefaultAppBar(
        title: "음식 스캔 결과",
        customLeading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.tertiaryText,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 12),
        itemCount: sortedLabels.length,
        itemBuilder: (context, index) {
          final category = sortedLabels.keys.elementAt(index);
          final foodList = sortedLabels[category]?.toSet().toList() ?? [];

          if (foodList.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _getCategoryColor(category),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _buildFoodItemGroup(context, foodList, category),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
