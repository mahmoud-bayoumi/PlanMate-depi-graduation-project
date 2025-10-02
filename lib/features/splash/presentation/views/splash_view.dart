import 'package:flutter/material.dart';
import 'package:planmate_app/core/utils/constants.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Color(kPrimaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
