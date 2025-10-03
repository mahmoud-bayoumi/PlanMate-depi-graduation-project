import 'package:flutter/material.dart';
import 'package:planmate_app/core/utils/constants.dart';

class GroupChatView extends StatelessWidget {
  const GroupChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Event Group Chat',
          style: TextStyle(
            color: Color(kPrimaryColor),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      
    );
  }
}
