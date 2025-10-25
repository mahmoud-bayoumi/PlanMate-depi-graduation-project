import 'package:flutter/material.dart';
import '../../../../../core/utils/constants.dart';

class DotsRow extends StatelessWidget {
  const DotsRow({
    super.key,
    required this.isLastPage,
  });

  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: !isLastPage ? 30 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: const Color(kPrimaryColor),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(width: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isLastPage ? 30 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: const Color(0xff4090FE),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    );
  }
}