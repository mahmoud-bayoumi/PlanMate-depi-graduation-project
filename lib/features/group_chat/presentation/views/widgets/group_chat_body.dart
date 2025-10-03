import 'package:flutter/material.dart';
import 'chat_bubble.dart';

class GroupChatBody extends StatelessWidget {
  const GroupChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              children: const [
                Divider(thickness: 1, color: Color(0xffECECEC)),
                ChatBubble(
                  isMe: false,
                  message: "Hello everyone! Excited for the event.",
                  username: "Bayoumi",
                  userColor: Colors.red,
                ),
                ChatBubble(
                  isMe: true,
                  message: "Hi Bayoumi! Me too.",
                  username: "You",
                  userColor: Colors.blue,
                ),
                ChatBubble(
                  isMe: false,
                  message: "Looking forward to meeting you all!",
                  username: "Yasser",
                  userColor: Colors.green,
                ),
                ChatBubble(
                  isMe: true,
                  message: "Same here, Yasser!",
                  username: "You",
                  userColor: Colors.blue,
                ),
                ChatBubble(
                  isMe: false,
                  message: "Don't forget to bring your tickets.",
                  username: "Omar",
                  userColor: Colors.orange,
                ),
                ChatBubble(
                  isMe: true,
                  message: "Got it, Omar. See you all there!",
                  username: "You",
                  userColor: Colors.blue,
                ),
                ChatBubble(
                  isMe: false,
                  message: "Don't forget to bring your tickets.",
                  username: "Omar",
                  userColor: Colors.orange,
                ),
                ChatBubble(
                  isMe: true,
                  message: "Got it, Omar. See you all there!",
                  username: "You",
                  userColor: Colors.blue,
                ),
                ChatBubble(
                  isMe: false,
                  message: "Don't forget to bring your tickets.",
                  username: "Omar",
                  userColor: Colors.orange,
                ),
                ChatBubble(
                  isMe: true,
                  message: "Got it, Omar. See you all there!",
                  username: "You",
                  userColor: Colors.blue,
                ),
                ChatBubble(
                  isMe: false,
                  message: "Looking forward to it!",
                  username: "Charlie",
                  userColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
