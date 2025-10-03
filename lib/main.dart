import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/group_chat/presentation/views/group_chat_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // <- make sure this runs
  runApp(const PlanMateApp());
}

class PlanMateApp extends StatelessWidget {
  const PlanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GroupChatView(),
    );
  }
}
