import 'package:flutter/material.dart';

class CyclesContainer extends StatelessWidget {
  final String image;
  const CyclesContainer({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/circles.png'),
        ),
      ),
      width: width,
      height: height * 0.5,
      child: Image.asset(image),
    );
  }
}
