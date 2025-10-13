import 'package:flutter/material.dart';

class ChatImageIcon extends StatelessWidget {
  const ChatImageIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Image.asset(
        'assets/images/chat.png',
        height: 35,
        width: 35,
      ),
    );
  }
}
