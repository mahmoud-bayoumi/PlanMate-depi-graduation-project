import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final Function(String)? onDateSelected;

  const DateInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (controller != null && controller!.text.isNotEmpty) {
      try {
        final parts = controller!.text.split('-');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        // Use current date if parsing fails
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1D61E7),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && controller != null) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      controller!.text = formattedDate;
      if (onDateSelected != null) {
        onDateSelected!(formattedDate);
      }
    }
  }

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
            readOnly: true,
            onTap: () => _selectDate(context),
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
              suffixIcon: const Icon(
                Icons.calendar_today,
                color: Color(0xFF6C7278),
                size: 20,
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