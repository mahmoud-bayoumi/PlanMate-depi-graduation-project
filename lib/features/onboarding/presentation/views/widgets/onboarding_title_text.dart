import 'package:flutter/material.dart';

class OnboardingTitleText extends StatelessWidget {
  final String title;
  const OnboardingTitleText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 28,
      ),
    );
  }
}
