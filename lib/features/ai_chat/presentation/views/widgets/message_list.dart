import 'package:flutter/material.dart';
import 'package:planmate_app/features/ai_chat/presentation/views/widgets/typing_indicator.dart';

import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<Map<String, String>> messages;
  final bool isTyping;

  const MessageList({
    super.key,
    required this.messages,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (isTyping && index == messages.length) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TypingIndicator(),
            ),
          );
        }

        final msg = messages[index];
        return MessageBubble(
          text: msg['text'] ?? "",
          isUser: msg['role'] == 'user',
        );
      },
    );
  }
}
