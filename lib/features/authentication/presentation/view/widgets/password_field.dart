import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'PlusJakartaSans',
            color: Color(0xFF6C7278),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'PlusJakartaSans',
              color: Color(0xFF6C7278),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFFACB5BB),
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1D61E7)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
