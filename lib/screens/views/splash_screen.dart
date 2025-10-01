import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PlanMate'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/PlanMateLogo.png",
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text('Welcome to PlanMate!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF1D61E7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
