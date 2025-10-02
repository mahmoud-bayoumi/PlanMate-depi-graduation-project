import 'package:flutter/material.dart';

import 'widgets/cycles_container.dart';
import 'widgets/onboarding_description.dart';
import 'widgets/onboarding_title_text.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          buildPage(
            imagePath: 'assets/images/illustrations.png',
            title: 'Easy to find events',
            description:
                'Connect with people who share your interests. Our platform helps you expand your network by meeting new and like-minded individuals.',
          ),
          buildPage(
            imagePath: 'assets/images/illustrations.png',
            title: 'Easy to find events',
            description:
                'Connect with people who share your interests. Our platform helps you expand your network by meeting new and like-minded individuals.',
          ),
        ],
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

/* 
   Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Color(kPrimaryColor),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Color(0xff4090FE),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'Next',
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


*/
