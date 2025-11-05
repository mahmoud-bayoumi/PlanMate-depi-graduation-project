
import 'package:flutter/material.dart';

class IconWithUnderLine extends StatelessWidget {
  const IconWithUnderLine({
    super.key,
    required this.icon,
  });
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        Container(
          height: 2,
          width: 24, //Adjust width as needed
          color: Colors.blue, //Underline color
        ),
      ],
    );
  }
}