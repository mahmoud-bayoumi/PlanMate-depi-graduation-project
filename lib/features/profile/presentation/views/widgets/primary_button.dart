import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6C7278),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color: Color(0xFF1A1C1E),
              letterSpacing: 0.01,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: Color(0x801A1C1E),
                letterSpacing: 0.01,
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}