import 'package:flutter/material.dart';
import '../../../../../core/utils/constants.dart';
import 'custom_animated_logo.dart';

class CustomAnimatedLogoContainer extends StatelessWidget {
  const CustomAnimatedLogoContainer({
    super.key,
    required this.width,
    required this.height,
    required Animation<double> anim,
    required this.logoScale,
  }) : _anim = anim;

  final double width;
  final double height;
  final Animation<double> _anim;
  final double logoScale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(kPrimaryColor),
          borderRadius: BorderRadius.circular(12 * _anim.value),
        ),
        child: CustomAnimatedLogo(logoScale: logoScale),
      ),
    );
  }
}