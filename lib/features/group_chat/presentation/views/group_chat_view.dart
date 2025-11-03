import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constants.dart';
import 'widgets/group_chat_body.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

class GroupChatView extends StatelessWidget {
  const GroupChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc()..add(LoadMessages()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Event Group Chat',
            style: TextStyle(
              color: Color(kPrimaryColor),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: const GroupChatBody(),
      ),
    );
  }
}