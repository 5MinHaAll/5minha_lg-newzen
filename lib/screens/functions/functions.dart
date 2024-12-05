import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../features/detection/yolo_live_screen.dart';
import '../../components/sliding_segment_control.dart';
import 'info_food.dart';
import 'info_microbe.dart';
import '../../theme/app_colors.dart';

class Functions extends StatelessWidget {
  const Functions({Key? key}) : super(key: key);

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final canLaunch = await canLaunchUrlString(url);
      if (canLaunch) {
        await launchUrlString(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('URL을 실행할 수 없습니다.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
      debugPrint('URL 실행 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondaryBackground,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 16),
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
          iconPath: 'assets/icons/functions/ic_osusume_usage.png',
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
      const SizedBox(height: 16),
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
      const SizedBox(height: 16),
      ConsumableInfo(
        onTap: (url) => _launchURL(context, url),
      ),
      const SizedBox(height: 16),
      _buildFeatureBox(
        context,
        _FeatureItem(
          icon: CupertinoIcons.chart_bar_alt_fill,
          iconColor: AppColors.primary,
          title: "에너지 모니터링",
          subtitle: "전력 사용량을 확인해보세요",
          onTap: () {},
        ),
      ),
      const SizedBox(height: 16),
      _buildFeatureBox(
        context,
        _FeatureItem(
          icon: CupertinoIcons.sparkles,
          iconColor: Colors.yellow,
          title: "가전세척 서비스 신청하기",
          subtitle: "LG전자의 전문적인 가전세척 서비스를 신청하실 수 있어요",
          onTap: () => _launchURL(
            context,
            'https://www.lge.co.kr/lg-best-care/home-appliance-cleaning?utm_source=thinq_app&af_dp=lgeapp%3A%2F%2Fgoto&utm_medium=deeplink&c=(AtW)%EA%B0%80%EC%A0%84%EC%84%B8%EC%B2%99%EC%8B%A0%EC%B2%AD(%EC%A0%84)&pid=appliancecleaning&deep_link_value=https%3A%2F%2Fwww.lge.co.kr%2Flg-best-care%2Fhome-appliance-cleaning%3Futm_source%3Dthinq_app&af_xp=referral&referrer=af_tranid%3Dyo4dOGeBbK9rNoqnpt0XqA%26utm_source%3Dthinq_app%26af_android_url%3Dhttps%3A%2F%2Fwww.lge.co.kr%2Flg-best-care%2Fhome-appliance-cleaning%26af_dp%3Dlgeapp%253A%252F%252Fgoto%26utm_medium%3Ddeeplink%26c%3D%28AtW%29%EA%B0%80%EC%A0%84%EC%84%B8%EC%B2%99%EC%8B%A0%EC%B2%AD%28%EC%A0%84%29%26pid%3Dappliancecleaning%26deep_link_value%3Dhttps%253A%252F%252Fwww.lge.co.kr%252Flg-best-care%252Fhome-appliance-cleaning%253Futm_source%253Dthinq_app%26af_ios_url%3Dhttps%3A%2F%2Fwww.lge.co.kr%2Flg-best-care%2Fhome-appliance-cleaning',
          ),
        ),
      ),
      const SizedBox(height: 16),
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const SizedBox(width: 40),
                      Expanded(
                        child: Text(
                          item.subtitle!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
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
          color: item.iconColor,
        ),
      );
    } else {
      return Icon(
        item.icon,
        size: 24,
        color: item.iconColor,
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
    return FilledButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const YoloLiveScreen()),
        );
      },
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.secondaryBackground,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            "스캔해서 확인하기",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
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

class ConsumableInfo extends StatelessWidget {
  final Function(String) onTap;

  const ConsumableInfo({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildFeatureBox(
      context,
      _FeatureItem(
        iconPath: 'assets/icons/functions/ic_shopping.png',
        title: "소모품 정보",
        subtitle: "내 제품에 필요한 소모품을 확인해보세요",
        onTap: () => onTap(
            'https://www.lge.co.kr/superCategory?superCategoryId=CT50020000'),
      ),
      extraContent: Column(
        children: [
          const SizedBox(height: 16),
          _buildConsumableCard(
            context: context,
            image: 'assets/images/functions/soil_package.png',
            name: '미생물 배양토',
            code: 'BIO75615001',
            discountRate: '10%',
            price: '22,500원',
            originalPrice: '25,000원',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBox(BuildContext context, _FeatureItem item,
      {Widget? extraContent}) {
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
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                        item.iconPath!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                  // const SizedBox(height: 4),
                  Row(
                    children: [
                      const SizedBox(width: 40),
                      Expanded(
                        child: Text(
                          item.subtitle!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (extraContent != null) extraContent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsumableCard({
    required BuildContext context,
    required String image,
    required String name,
    required String code,
    required String discountRate,
    required String price,
    required String originalPrice,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '($code)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      discountRate,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.heritageRed,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      price,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primaryText,
                          ),
                    ),
                  ],
                ),
                Text(
                  originalPrice,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
