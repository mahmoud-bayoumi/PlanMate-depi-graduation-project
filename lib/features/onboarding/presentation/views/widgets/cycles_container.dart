import 'package:flutter/material.dart';

class CyclesContainer extends StatelessWidget {
  final String image;
  const CyclesContainer({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/circles.png'),
        ),
      ),
      child: Image.asset(image),
    );
  }
}
