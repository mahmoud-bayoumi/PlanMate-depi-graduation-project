import 'package:flutter/material.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/dots_row.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/next_text_button.dart';

class FIrstPageBottomSheet extends StatelessWidget {
  const FIrstPageBottomSheet({
    super.key,
    required this.isLastPage,
    required PageController controller,
  }) : _controller = controller;

  final bool isLastPage;
  final PageController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 40,
      ),
      child: Row(
        children: [
          DotsRow(isLastPage: isLastPage),
          const Spacer(),
          NextTextButton(controller: _controller),
        ],
      ),
    );
  }
}
