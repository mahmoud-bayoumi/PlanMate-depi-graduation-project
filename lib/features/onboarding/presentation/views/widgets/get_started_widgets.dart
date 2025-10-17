import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../../../../core/utils/constants.dart';
import '../../../../authentication/services/auth_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';
=======
import 'package:planmate_app/core/utils/constants.dart';

import 'package:planmate_app/features/ai_chat/presentation/views/ai_chat_view.dart';


>>>>>>> eca6ed2 (WIP: local updates before pulling latest version)

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(350, 60),
          backgroundColor: const Color(kPrimaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
<<<<<<< HEAD
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasSeenOnboarding', true);

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AuthGate()),
            );
          }
=======
        onPressed: () {
          Navigator.pushReplacement(
            context,

           MaterialPageRoute(builder: (_) => const PlanMateAIChatView()),

            MaterialPageRoute(builder: (_) => const Placeholder()),

          );
>>>>>>> eca6ed2 (WIP: local updates before pulling latest version)
        },
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
