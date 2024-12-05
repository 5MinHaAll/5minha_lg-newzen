import 'package:flutter/material.dart';
import '../../components/appbar_tab.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

class InfoMicrobe extends StatefulWidget {
  const InfoMicrobe({Key? key}) : super(key: key);

  @override
  _InfoMicrobeState createState() => _InfoMicrobeState();
}

class _InfoMicrobeState extends State<InfoMicrobe>
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

  Widget _buildInfoCard(String title, String content,
      {IconData? icon, Color? iconColor}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Row(
                children: [
                  Icon(icon,
                      color: iconColor ?? Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              content,
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(String title, String description, IconData icon,
      {Color? iconColor}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              (iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
          child: Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
        ),
        title: Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.tertiaryText,
          ),
        ),
        subtitle: Text(
          description,
          style: AppTypography.bodySmall,
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "미생물은 음식물 처리의 핵심입니다. 건강한 미생물 환경을 유지하면 처리 효율이 높아지고 악취도 줄일 수 있습니다.",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),

        // 미생물 활성화 관리 섹션
        Text(
          "미생물 활성화 관리",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          "온도 관리",
          "교반통의 내부 온도는 미생물 활동에 직접적인 영향을 미치므로 철저히 관리해주세요.",
          icon: Icons.thermostat,
        ),
        _buildInfoCard(
          "습도 관리",
          "교반통의 내부 습도는 60-70% 사이로 유지하는 것이 좋습니다. 너무 건조하거나 습하면 미생물 활동이 둔화됩니다.",
          icon: Icons.water_drop,
        ),
        _buildInfoCard(
          "처리량 관리",
          "미생물이 처리할 수 있는 양은 하루 최대 4kg입니다. 과도한 투입은 미생물에게 큰 부담을 줍니다.",
          icon: Icons.scale,
        ),

        // 부산물 관리 섹션
        const SizedBox(height: 24),
        Text(
          "부산물 관리",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          "정기 점검",
          "일주일에 한 번은 부산물량을 확인해주세요. 부산물이 많으면 처리 속도가 늦어질 수 있습니다.",
          icon: Icons.calendar_today,
        ),
        _buildInfoCard(
          "처리 방법",
          "퇴비로 활용 시 흙과 9:1 비율로 섞어주세요. 잘 관리된 부산물은 훌륭한 천연 비료가 됩니다.",
          icon: Icons.recycling,
        ),

        // 작동 모드 섹션
        const SizedBox(height: 24),
        Text(
          "작동 모드",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildModeCard(
          "일반 모드",
          "일상적인 음식물 처리를 위한 기본 모드입니다.",
          Icons.play_arrow,
          iconColor: AppColors.secondary,
        ),
        _buildModeCard(
          "외출 모드",
          "집을 비울 때 사용하는 강력한 발효 모드입니다.",
          Icons.directions_walk,
          iconColor: Colors.orange,
        ),
        _buildModeCard(
          "절전 모드",
          "장기간 미사용 시 미생물 유지를 위한 모드입니다.",
          Icons.eco,
          iconColor: Colors.green,
        ),
        _buildModeCard(
          "세척 모드",
          "월 1회 이상 기기 내부 청소 시 사용하는 모드입니다.",
          Icons.waves,
          iconColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatusCard(
      String title, String value, String unit, Color color) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 현재 상태 그리드
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatusCard("내부 온도", "25", "°C", Colors.orange),
            _buildStatusCard("내부 습도", "65", "%", Colors.blue),
            _buildStatusCard("부산물량", "60", "%", Colors.green),
            _buildStatusCard("일일 처리량", "2.5", "kg", Colors.purple),
          ],
        ),
        const SizedBox(height: 24),

        // 미생물 상태 게이지
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "미생물 활성도",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.8,
                    backgroundColor: Colors.grey[200],
                    color: Theme.of(context).primaryColor,
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "현재 상태: ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryText,
                          ),
                    ),
                    Text(
                      "양호",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        title: "미생물 관리",
        tabController: _tabController,
        tabs: const ["정보", "상태"],
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
          _buildStatusTab(),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
