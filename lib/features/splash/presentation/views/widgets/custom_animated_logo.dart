import 'package:flutter/material.dart';

class CustomAnimatedLogo extends StatelessWidget {
  const CustomAnimatedLogo({
    super.key,
    required this.logoScale,
  });

  final double logoScale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: logoScale,
        child: Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
