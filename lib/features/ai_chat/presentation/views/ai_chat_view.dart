import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:planmate_app/features/ai_chat/presentation/views/widgets/chat_input.dart';
import 'package:planmate_app/features/ai_chat/presentation/views/widgets/message_list.dart';

class PlanMateAIChatView extends StatefulWidget {
  const PlanMateAIChatView({super.key});

  @override
  State<PlanMateAIChatView> createState() => _PlanMateAIChatViewState();
}

class _PlanMateAIChatViewState extends State<PlanMateAIChatView> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  late GenerativeModel _model;
  late ChatSession _chat;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception("API Key not found!");
    }
    _model = GenerativeModel(
      model: 'models/gemini-2.5-flash',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _controller.clear();
      _isTyping = true;
    });

    try {
      final response = await _chat.sendMessage(Content.text(userMessage));
      setState(() {
        _messages.add({'role': 'bot', 'text': response.text ?? "No response"});
      });
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PlanMate AI Chat")),
      body: Column(
        children: [
          Expanded(
            child: MessageList(messages: _messages, isTyping: _isTyping),
          ),
          ChatInput(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
