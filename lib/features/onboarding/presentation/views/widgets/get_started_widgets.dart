import 'package:flutter/material.dart';
import 'package:planmate_app/core/utils/constants.dart';
//<<<<<<< Updated upstream
import 'package:planmate_app/features/authentication/services/auth_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';
//=======
//>>>>>>> Stashed changes

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40.0,
        horizontal: 8,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(350, 60),
          backgroundColor: const Color(kPrimaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasSeenOnboarding', true);

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AuthGate()),
            );
          }
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
