import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final bool showLogo;

  const AuthHeader({
    super.key,
    required this.title,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showLogo) ...[
          Center(
            child: Image.asset(
              'assets/images/PlanMateLogo.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 20),
        ],
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              color: Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }
}
