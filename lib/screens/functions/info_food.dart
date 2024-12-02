import 'package:flutter/material.dart';
import '../../components/appbar_tab.dart';
import '../../features/detection/waste_categories.dart';

class InfoFood extends StatefulWidget {
  const InfoFood({Key? key}) : super(key: key);

  @override
  _InfoFoodState createState() => _InfoFoodState();
}

class _InfoFoodState extends State<InfoFood>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildGuideSection(String title, String content) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "효율적인 음식물 처리와 기기 보호를 위해 음식물을 올바르게 분류하는 것이 중요합니다. 아래 가이드를 참고하여 안전하게 사용해주세요.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Text(
          "투입 가능한 음식물",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildGuideSection("과일/야채류는 안심하고 넣어주세요",
            "대부분의 과일과 야채는 미생물이 잘 분해할 수 있습니다. 단, 크기가 큰 경우 잘게 잘라주세요."),
        _buildGuideSection("조리된 음식은 모두 넣을 수 있어요",
            "밥, 국, 반찬 등 모든 조리된 음식물을 넣을 수 있습니다. 국물은 최대한 제거하고 투입해주세요."),
        _buildGuideSection("부드러운 생선과 고기는 가능해요",
            "뼈를 제거한 생선살과 잘게 자른 고기는 처리할 수 있습니다. 기름기가 많은 부위는 피해주세요."),
        _buildGuideSection("발효식품도 처리할 수 있어요",
            "김치, 장류는 물기를 빼고 넣어주세요. 염분이 높은 음식은 소량만 투입하는 것이 좋습니다."),
        const SizedBox(height: 24),
        Text(
          "투입할 수 없는 음식물",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildGuideSection("딱딱한 음식물은 넣지 마세요",
            "뼈, 조개껍데기, 생선 내장은 고장의 원인이 됩니다. 특히 닭뼈는 기기에 심각한 손상을 줄 수 있어요."),
        _buildGuideSection("기름진 음식은 피해주세요",
            "기름기가 많은 음식은 미생물 활동을 방해합니다. 튀김이나 기름진 고기는 기름을 제거하고 넣어주세요."),
        _buildGuideSection("질긴 껍질류는 넣지 마세요",
            "양파껍질, 옥수수껍질, 생강 등은 처리가 어렵습니다. 이런 음식물은 미생물이 분해하는 데 매우 오랜 시간이 걸려요."),
        _buildGuideSection("씨앗류는 제외해주세요",
            "과일씨, 곡물씨 등은 미생물이 분해하지 못합니다. 단단한 씨앗은 기기 고장의 원인이 될 수 있어요."),
      ],
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getStatusColor(food['status']),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: food['number'] != null && food['fileName'] != null
                ? Image.asset(
                    'assets/images/functions/info_food/${food['number']}-${food['fileName']}.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.restaurant,
                        size: 32,
                        color: Colors.grey,
                      );
                    },
                  )
                : Icon(
                    Icons.restaurant,
                    size: 32,
                    color: Colors.grey,
                  ),
          ),
        ),
        title: Text(
          food['name_ko'],
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food['category'],
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              food['details'],
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '처리 가능':
        return Colors.green.shade50;
      case '주의 필요':
        return Colors.orange.shade50;
      case '처리 불가':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Widget _buildFoodSection(String title, List<Map<String, dynamic>> foods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...foods.map((food) => _buildFoodCard(food)).toList(),
      ],
    );
  }

  Widget _buildFoodTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildFoodSection('처리 가능한 음식물',
            wasteCategories['processable'] as List<Map<String, dynamic>>),
        _buildFoodSection('주의가 필요한 음식물',
            wasteCategories['caution'] as List<Map<String, dynamic>>),
        _buildFoodSection('처리 불가능한 음식물',
            wasteCategories['nonProcessable'] as List<Map<String, dynamic>>),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        title: "음식물 분류 가이드",
        tabController: _tabController,
        tabs: const ["정보", "음식"],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 검색 기능
            },
          ),
        ],
        tabColor: Colors.black,
        unselectedTabColor: Colors.grey,
        indicatorColor: const Color(0xFF65558F),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(),
          _buildFoodTab(),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
