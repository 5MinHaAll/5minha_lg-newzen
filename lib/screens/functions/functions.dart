import 'package:flutter/material.dart';
import 'package:newzen/features/detection/main_screen.dart';
import '../info/info.dart';

class Functions extends StatelessWidget {
  const Functions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 45),

            Stack(
              children: [
                _buildFeatureCard(
                  context,
                  "미생물 관리",
                  "",
                  Icons.arrow_forward_ios,
                  theme.colorScheme.primaryContainer,
                      () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Info()),
                    );
                  },
                ),
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MainScreen(title: 'YOLO')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "처리 가능한 음식물",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),

            _buildFeatureCard(
              context,
              "소모품 정보",
              "내 제품에 필요한 소모품을 확인해보세요.",
              null,
              theme.colorScheme.primaryContainer,
                  () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: const Text('소모품 정보 페이지로 이동합니다.'),
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                  );
              },
            ),
            const SizedBox(height: 45),

            _buildFeatureCard(
              context,
              "에너지 모니터링",
              "전력 사용량",
              Icons.arrow_forward_ios,
              theme.colorScheme.secondaryContainer,
                  () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: const Text('에너지 모니터링 페이지로 이동합니다.'),
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                  );
              },
            ),
            const SizedBox(height: 45),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    "스마트 진단",
                    "최근 진단 결과 없음",
                    null,
                    theme.colorScheme.secondaryContainer,
                        () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: const Text('스마트 진단 페이지로 이동합니다.'),
                            backgroundColor: theme.colorScheme.secondary,
                          ),
                        );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    "제품 사용설명서",
                    "사용법이 궁금하신가요?",
                    null,
                    theme.colorScheme.secondaryContainer,
                        () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: const Text('제품 사용설명서 페이지로 이동합니다.'),
                            backgroundColor: theme.colorScheme.secondary,
                          ),
                        );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData? icon,
      Color backgroundColor,
      VoidCallback onTap,
      ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (icon != null)
              Icon(
                icon,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}