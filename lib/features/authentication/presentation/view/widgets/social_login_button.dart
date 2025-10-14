import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;

  const SocialLoginButton({
    super.key,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEFF0F6)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
