// food_detail.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'waste_categories.dart';

class FoodDetail extends StatelessWidget {
  final String foodName;
  final String category;

  const FoodDetail({
    required this.foodName,
    required this.category,
    super.key,
  });

  String get _effectiveCategory => _findCorrectCategory();

  String _findCorrectCategory() {
    for (final categoryKey in ['processable', 'caution', 'nonProcessable']) {
      final categoryList = wasteCategories[categoryKey] as List?;
      if (categoryList != null) {
        final found = categoryList.any((food) =>
            (food['name'] as String).toLowerCase() == foodName.toLowerCase());
        if (found) {
          switch (categoryKey) {
            case 'processable':
              return '처리 가능';
            case 'caution':
              return '주의 필요';
            case 'nonProcessable':
              return '처리 불가능';
          }
        }
      }
    }
    return category;
  }

  String _getImagePath(Map<String, dynamic>? foodInfo) {
    if (foodInfo == null) {
      debugPrint('foodInfo is null');
      return '';
    }

    final imgNumber = foodInfo['imgNumber'] as String?;
    final name = foodInfo['name'] as String?;

    if (imgNumber == null || name == null) {
      debugPrint(
          'imgNumber or name is null. imgNumber: $imgNumber, name: $name');
      return '';
    }

    final fileName = name.toLowerCase();
    final number = imgNumber.padLeft(2, '0');
    final path = 'assets/images/functions/info_food/$number-$fileName.png';
    debugPrint('Trying to load image: $path');
    return path;
  }

  String _getCategoryKey() {
    debugPrint('Original category: $_effectiveCategory');
    switch (_effectiveCategory.trim()) {
      case "처리 가능":
        return "processable";
      case "주의":
      case "주의 필요":
        return "caution";
      case "처리 불가":
      case "처리 불가능":
        return "nonProcessable";
      default:
        debugPrint('Category not matched: $_effectiveCategory');
        return "processable";
    }
  }

  Map<String, dynamic>? _getFoodInfo() {
    try {
      final categoryKey = _getCategoryKey();
      debugPrint('Category Key: $categoryKey');

      if (!wasteCategories.containsKey(categoryKey)) {
        debugPrint('Category not found: $categoryKey');
        return {"name": foodName, "name_ko": foodName, "status": category};
      }

      final categoryList = List<Map<String, dynamic>>.from(
          (wasteCategories[categoryKey] as List)
              .map((item) => Map<String, dynamic>.from(item as Map)));

      debugPrint('Searching for food: $foodName');
      debugPrint(
          'Available foods in category: ${categoryList.map((food) => food["name"]).toList()}');

      return categoryList.firstWhere(
        (food) =>
            food["name"].toString().toLowerCase() == foodName.toLowerCase(),
        orElse: () {
          debugPrint('Food not found: $foodName');
          return {"name": foodName, "name_ko": foodName, "status": category};
        },
      );
    } catch (e) {
      debugPrint('Error in _getFoodInfo: $e');
      return {"name": foodName, "name_ko": foodName, "status": category};
    }
  }

  String _getGuidelineDetail(Map<String, dynamic>? foodInfo,
      Map<String, dynamic>? categoryGuidelines) {
    if (foodInfo == null || categoryGuidelines == null) {
      debugPrint('foodInfo or categoryGuidelines is null');
      return "";
    }

    final imgNumber = foodInfo['imgNumber'] as String?;
    if (imgNumber == null) {
      debugPrint('imgNumber is null');
      return foodInfo['details'] ?? "";
    }

    final detailsMap = categoryGuidelines['details'] as Map<String, dynamic>?;
    if (detailsMap == null) {
      debugPrint('detailsMap is null');
      return foodInfo['details'] ?? "";
    }

    debugPrint('Looking for details with imgNumber: $imgNumber');

    if (detailsMap.containsKey(imgNumber)) {
      return detailsMap[imgNumber];
    }

    for (final key in detailsMap.keys) {
      final range = key.split('-');
      try {
        if (range.length == 2) {
          final start = int.parse(range[0]);
          final end = int.parse(range[1]);
          final current = int.parse(imgNumber);
          if (current >= start && current <= end) {
            debugPrint('Found range match: $key for number: $imgNumber');
            return detailsMap[key];
          }
        }
      } catch (e) {
        debugPrint('Error parsing number range: $e');
      }
    }

    debugPrint('No matching details found, returning original details');
    return foodInfo['details'] ?? "";
  }

  List<String> _getExamples(Map<String, dynamic>? foodInfo,
      Map<String, dynamic>? categoryGuidelines) {
    if (foodInfo == null || categoryGuidelines == null) {
      return [];
    }

    final examples = categoryGuidelines['examples'] as List?;
    return examples?.cast<String>() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final foodInfo = _getFoodInfo();
    final koreanName = foodInfo?["name_ko"] ?? foodName;

    debugPrint('Food Info: $foodInfo');

    final guidelines = wasteCategories['guidelines'];
    final categoryKey = _getCategoryKey();
    final categoryGuidelines = guidelines != null
        ? (guidelines as Map<String, dynamic>)[categoryKey]
            as Map<String, dynamic>?
        : null;

    debugPrint('Category Guidelines: $categoryGuidelines');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF1F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                          color: AppColors.secondaryText,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          koreanName,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.primaryText,
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          foodInfo?["category"] ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackground,
                          ),
                          child: Image.asset(
                            _getImagePath(foodInfo),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Error loading image: $error');
                              return const Icon(
                                Icons.fastfood,
                                size: 48,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          categoryGuidelines?['title'] as String? ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: category == "처리 가능"
                                        ? AppColors.success
                                        : category == "주의"
                                            ? AppColors.warning
                                            : AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categoryGuidelines?['subtitle'] as String? ?? "",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        if (_getGuidelineDetail(foodInfo, categoryGuidelines)
                            .isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "이렇게 처리하세요",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryText,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "• ${_getGuidelineDetail(foodInfo, categoryGuidelines)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.secondaryText,
                                      ),
                                  softWrap: true,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "처리 방법이 비슷해요",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryText,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                ..._getExamples(foodInfo, categoryGuidelines)
                                    .map((example) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 0),
                                          child: Text(
                                            "• $example",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color:
                                                      AppColors.secondaryText,
                                                ),
                                            softWrap: true,
                                          ),
                                        )),
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
