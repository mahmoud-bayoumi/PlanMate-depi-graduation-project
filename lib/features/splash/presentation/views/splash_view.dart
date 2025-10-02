import 'package:flutter/material.dart';
import 'package:planmate_app/core/utils/constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _anim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
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
          return Center(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: const Color(kPrimaryColor),
                borderRadius: BorderRadius.circular(12 * _anim.value),
              ),
              child: Center(
                child: Transform.scale(
                  scale: logoScale,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
