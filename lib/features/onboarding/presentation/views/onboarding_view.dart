import 'package:flutter/material.dart';
import 'widgets/get_started_widgets.dart';
import 'widgets/cycles_container.dart';
import 'widgets/first_page_bottom_sheet.dart';
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
          ? const GetStartedButton()
          // First Page → Indicator + Next Button
          : FIrstPageBottomSheet(
              isLastPage: isLastPage,
              controller: _controller,
            ),
    );
  }

  SingleChildScrollView buildPage({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CyclesContainer(
            image: imagePath,
          ),
          const SizedBox(
            height: 41,
          ),
          OnboardingTitleText(
            title: title,
          ),
          const SizedBox(
            height: 21,
          ),
          OnboardingDescription(
            description: description,
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
