import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../features/detection/yolo_live_screen.dart';
import '../../components/sliding_segment_control.dart';
import 'info_food.dart';
import 'info_microbe.dart';
import '../../theme/app_colors.dart';

class Functions extends StatelessWidget {
  const Functions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondaryBackground,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildFeatureSection(
              context,
              [
                _FeatureItem(
                  icon: CupertinoIcons.doc_text,
                  title: "음식물 분류 가이드",
                  subtitle: "투입 가능한 음식물을 확인해보세요",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const InfoFood()),
                    );
                  },
                  actionButton: _buildScanButton(context),
                ),
                _FeatureItem(
                  icon: CupertinoIcons.waveform_path_ecg,
                  title: "미생물 관리",
                  subtitle: "내 제품과 미생물 관리 방법을 확인해보세요",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const InfoMicrobe()),
                    );
                  },
                ),
                _FeatureItem(
                  icon: CupertinoIcons.cart,
                  title: "소모품 정보",
                  subtitle: "내 제품에 필요한 소모품을 확인해보세요",
                  onTap: () {
                    // TODO: 웹링크 추가
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildFeatureSection(
              context,
              [
                _FeatureItem(
                  icon: CupertinoIcons.chart_bar,
                  title: "에너지 모니터링",
                  subtitle: "전력 사용량을 확인해보세요",
                  onTap: () {},
                ),
                _FeatureItem(
                  icon: CupertinoIcons.sparkles,
                  title: "가전세척 서비스 신청하기",
                  subtitle: "LG전자의 전문적인 가전세척 서비스를 신청하실 수 있어요",
                  onTap: () {
                    // TODO: 웹링크 추가
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSmallFeatureCard(
                      context,
                      CupertinoIcons.device_phone_portrait,
                      "스마트 진단",
                      "최근 진단 결과 없음",
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSmallFeatureCard(
                      context,
                      CupertinoIcons.book,
                      "제품 사용설명서",
                      "사용법이 궁금하신가요?",
                      onTap: () {
                        // TODO: 웹링크 추가
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kBottomNavigationBarHeight + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection(BuildContext context, List<_FeatureItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final int idx = entry.key;
          final item = entry.value;
          final bool isLast = idx == items.length - 1;

          return Column(
            children: [
              _buildFeatureListTile(context, item),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEFF1F5),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureListTile(BuildContext context, _FeatureItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 24,
                color: AppColors.tertiary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (item.actionButton != null)
                item.actionButton!
              else
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.tertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.tertiary),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const YoloLiveScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        "스캔해서 확인하기",
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? actionButton;

  _FeatureItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.actionButton,
  });
}
