import 'package:flutter/material.dart';

class BottomBarIcon extends StatelessWidget {
  const BottomBarIcon({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: isActive ? Colors.blue : Colors.black),
    );
  }
}
