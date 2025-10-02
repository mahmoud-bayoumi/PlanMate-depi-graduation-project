import 'package:flutter/material.dart';
import 'package:planmate_app/features/splash/presentation/views/splash_view.dart';

void main() {
  runApp(const PlanMateApp());
}

class PlanMateApp extends StatelessWidget {
  const PlanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
