import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final TextEditingController? controller;

  const PasswordField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.isVisible,
    required this.onToggleVisibility,
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
            letterSpacing: -0.02,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
          ),
          child: TextField(
            controller: controller,
            obscureText: !isVisible,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 18,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                color: Color(0x801A1C1E),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0x801A1C1E),
                  size: 22,
                ),
                onPressed: onToggleVisibility,
              ),
            ),
          ),
        ),
      ],
    );
  }
}