import 'package:flutter/material.dart';
import '../../../../../core/utils/constants.dart';

class NextTextButton extends StatelessWidget {
  const NextTextButton({
    super.key,
    required PageController controller,
  }) : _controller = controller;

  final PageController _controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: const Row(
        children: [
          Text(
            "Next",
            style: TextStyle(
              color: Color(kPrimaryColor),
              fontSize: 18,
            ),
          ),
          Icon(
            Icons.arrow_right_alt,
            color: Color(kPrimaryColor),
            size: 36,
          ),
        ],
      ),
    );
  }
}
