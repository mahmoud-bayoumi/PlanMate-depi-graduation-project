import 'package:flutter/material.dart';

import '../../../../group_chat/presentation/views/group_chat_view.dart';

class ChatImageIcon extends StatelessWidget {
  const ChatImageIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          (MaterialPageRoute(
            builder: (context) {
              return const GroupChatView();
            },
          )),
        );
      },
      child: Image.asset('assets/images/chat.png', height: 35, width: 35),
    );
  }
}
