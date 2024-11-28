import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String icon;
  final String title;
  final bool isOn;
  final VoidCallback onTogglePower;
  final VoidCallback? onIconTap;

  const DeviceCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.isOn,
    required this.onTogglePower,
    this.onIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isOn ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onIconTap,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 디바이스 이미지
                    Image.asset(
                      icon,
                      height: 40,
                      width: 40,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.device_unknown,
                        size: 40,
                        color: isOn ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 디바이스 이름
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 전원 상태
                    Text(
                      isOn ? "켜짐" : "꺼짐",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // 전원 버튼
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: onTogglePower,
                  child: Image.asset(
                    isOn
                        ? 'assets/icons/tuc/btn_appliance_power_on_nor.png'
                        : 'assets/icons/tuc/btn_appliance_power_off_nor.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
