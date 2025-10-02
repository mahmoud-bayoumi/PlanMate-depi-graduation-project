import 'package:flutter/material.dart';
import 'package:planmate_app/core/utils/constants.dart';

import 'widgets/cycles_container.dart';
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
          ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 8,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350, 60),
                  backgroundColor: const Color(kPrimaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Placeholder()),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          // First Page → Indicator + Next Button
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 40,
              ),
              child: Row(
                children: [
                  // Custom Page Indicator
                  Row(
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
                  ),
                  const Spacer(),

                  // Next Button
                  TextButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Row(
                      children: const [
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
                  ),
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
