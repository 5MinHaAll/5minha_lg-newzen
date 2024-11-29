import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;

  const HomeAppBar({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Text(
            "$userName 홈",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF4F4F4F),
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Color(0xFF4F4F4F),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Color(0xFF4F4F4F)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Color(0xFF4F4F4F)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFF4F4F4F)),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
