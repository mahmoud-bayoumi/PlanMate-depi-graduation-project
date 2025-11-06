import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constants.dart';
import '../../bloc/chat_bloc.dart';
import '../../bloc/chat_event.dart';
import '../../bloc/chat_state.dart';
import 'chat_bubble.dart';

class GroupChatBody extends StatefulWidget {
  const GroupChatBody({super.key});

  @override
  State<GroupChatBody> createState() => _GroupChatBodyState();
}

class _GroupChatBodyState extends State<GroupChatBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                } else if (state is ChatLoaded) {
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final currentUserId = context
                          .read<ChatBloc>()
                          .currentUser
                          ?.uid;
                      String displayEmail =
                          context.read<ChatBloc>().currentUser?.email ??
                          'Unknown';
                      Color getUserColor(String uid) {
                        final hash = uid.hashCode;
                        return Color((hash & 0xFFFFFF) | 0xFF20c0d00);
                      }

                      final isMe = msg['senderId'] == currentUserId;
                      return GestureDetector(
                        onLongPress: () {
                          if (isMe) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete Message"),
                                content: const Text(
                                  "Are you sure you want to delete this message?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      context.read<ChatBloc>().add(
                                        DeleteMessage(msg['id'] ?? ''),
                                      );
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: ChatBubble(
                          isMe: isMe,
                          message: msg['text'] ?? '',
                          username: isMe
                              ? 'You'
                              : (msg['senderName'] ?? 'Unknown'),
                          userColor: isMe
                              ? Colors.blue
                              : getUserColor(msg['senderId']),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
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
                  controller: _controller,
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
                backgroundColor: const Color(kPrimaryColor),
                child: IconButton(
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<ChatBloc>().add(SendMessage(text));
                      _controller.clear();
                    }
                  },
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