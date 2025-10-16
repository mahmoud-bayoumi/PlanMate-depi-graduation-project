import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final double iconSize;

  const ProfileAvatar({super.key, this.size = 140, this.iconSize = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD4D4F5),
      ),
      child: const Center(
        child: Icon(Icons.person, size: 80, color: Color(0xFF0601B4)),
      ),
    );
  }
}
