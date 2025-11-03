import 'package:flutter/material.dart';

class OnboardingDescription extends StatelessWidget {
  final String description;
  const OnboardingDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        description,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        maxLines: 4,
      ),
    );
  }
}