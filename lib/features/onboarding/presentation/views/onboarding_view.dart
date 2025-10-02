import 'package:flutter/material.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/get_started_widgets.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/next_text_button.dart';

import 'widgets/cycles_container.dart';
import 'widgets/dots_row.dart';
import 'widgets/onboarding_description.dart';
import 'widgets/onboarding_title_text.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            isLastPage = index == 1;
          });
        },
        children: [
          buildPage(
            imagePath: 'assets/images/illustrations.png',
            title: 'Easy to find events',
            description:
                'Discover a variety of events tailored to your interests. Our platform makes it simple to browse and find what matters most to you.',
          ),
          buildPage(
            imagePath: 'assets/images/illustration.png',
            title: 'Meet with new folks',
            description:
                'Connect with people who share your interests. Our platform helps you expand your network by meeting new and like-minded individuals.',
          ),
        ],
      ),
      bottomSheet: isLastPage
          // Last Page → Big Button
          ? GetStartedButton()
          // First Page → Indicator + Next Button
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 40,
              ),
              child: Row(
                children: [
                  // Custom Page Indicator
                  DotsRow(isLastPage: isLastPage),
                  const Spacer(),

                  // Next Button
                  NextTextButton(controller: _controller),
                ],
              ),
            ),
    );
  }

  SingleChildScrollView buildPage({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CyclesContainer(
            image: imagePath,
          ),
          SizedBox(
            height: 41,
          ),
          OnboardingTitleText(
            title: title,
          ),
          SizedBox(
            height: 21,
          ),
          OnboardingDescription(
            description: description,
          ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
