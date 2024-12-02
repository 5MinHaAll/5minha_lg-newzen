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
            ..._buildFeatureBoxes(context),
            const SizedBox(height: kBottomNavigationBarHeight + 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureBoxes(BuildContext context) {
    return [
      _buildFeatureBox(
        context,
        _FeatureItem(
          iconPath: 'assets/icons/functions/ic_info_square.png',
          title: "음식물 분류 가이드",
          subtitle: "투입 가능한 음식물을 확인해보세요",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const InfoFood()),
            );
          },
          actionButton: _buildScanButton(context),
        ),
      ),
      const SizedBox(height: 12),
      _buildFeatureBox(
        context,
        _FeatureItem(
          iconPath: 'assets/icons/functions/ic_microbe_mgt.png',
          title: "미생물 활용 가이드",
          subtitle: "내 제품과 미생물 관리 방법을 확인해보세요",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const InfoMicrobe()),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      _buildFeatureBox(
        context,
        _FeatureItem(
          iconPath: 'assets/icons/functions/ic_shopping.png',
          title: "소모품 정보",
          subtitle: "내 제품에 필요한 소모품을 확인해보세요",
          onTap: () {
            // TODO: 웹링크 추가
          },
        ),
      ),
      const SizedBox(height: 24),
      _buildFeatureBox(
        context,
        _FeatureItem(
          icon: CupertinoIcons.chart_bar_alt_fill,
          title: "에너지 모니터링",
          subtitle: "전력 사용량을 확인해보세요",
          onTap: () {},
        ),
      ),
      const SizedBox(height: 12),
      _buildFeatureBox(
        context,
        _FeatureItem(
          icon: CupertinoIcons.sparkles,
          iconColor: Colors.yellow,
          title: "가전세척 서비스 신청하기",
          subtitle: "LG전자의 전문적인 가전세척 서비스를 신청하실 수 있어요",
          onTap: () {
            // TODO: 웹링크 추가
          },
        ),
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: _buildSmallFeatureCard(
                context,
                "스마트 진단",
                "최근 진단 결과 없음",
                iconPath: 'assets/icons/functions/ic_smart_diagnosis.png',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSmallFeatureCard(
                context,
                "제품 사용설명서",
                "사용법이 궁금하신가요?",
                iconPath: 'assets/icons/functions/ic_manual_big.png',
                onTap: () {
                  // TODO: 웹링크 추가
                },
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildFeatureBox(BuildContext context, _FeatureItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildFeatureIcon(item),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.tertiary,
                    ),
                  ],
                ),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const SizedBox(width: 40),
                      Expanded(
                        child: Text(
                          item.subtitle!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (item.actionButton != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      item.actionButton!,
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(_FeatureItem item) {
    if (item.iconPath != null) {
      return SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          item.iconPath!,
          fit: BoxFit.contain,
          // color: item.iconColor ?? AppColors.tertiary,
        ),
      );
    } else {
      return Icon(
        item.icon,
        size: 24,
        // color: item.iconColor ?? AppColors.tertiary,
      );
    }
  }

  Widget _buildSmallFeatureCard(
    BuildContext context,
    String title,
    String subtitle, {
    IconData? icon,
    String? iconPath,
    required VoidCallback onTap,
  }) {
    Widget iconWidget;
    if (iconPath != null) {
      iconWidget = SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
          color: AppColors.tertiary,
        ),
      );
    } else {
      iconWidget = Icon(icon, color: AppColors.tertiary);
    }

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
                iconWidget,
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
  final IconData? icon;
  final String? iconPath;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? actionButton;
  final Color? iconColor;

  _FeatureItem({
    this.icon,
    this.iconPath,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.actionButton,
    this.iconColor,
  }) : assert(icon != null || iconPath != null,
            'Either icon or iconPath must be provided');
}
