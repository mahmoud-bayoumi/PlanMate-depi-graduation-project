import 'package:flutter/material.dart';
import 'custom_animated_logo_container.dart';

class LogoAnimatedBuilder extends StatelessWidget {
  const LogoAnimatedBuilder({
    super.key,
    required AnimationController controller,
    required this.size,
    required Animation<double> anim,
  }) : _controller = controller,
       _anim = anim;

  final AnimationController _controller;
  final Size size;
  final Animation<double> _anim;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double width = Tween<double>(
          begin: size.width,
          end: 100,
        ).evaluate(_anim);

        final double height = Tween<double>(
          begin: size.height,
          end: 100,
        ).evaluate(_anim);

        final double logoScale = Tween<double>(
          begin: 0.2,
          end: 1.0,
        ).evaluate(_anim);
        return CustomAnimatedLogoContainer(
          width: width,
          height: height,
          anim: _anim,
          logoScale: logoScale,
        );
      },
    );
  }
}
