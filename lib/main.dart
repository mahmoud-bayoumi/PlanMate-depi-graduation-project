import 'package:flutter/material.dart';
import 'features/splash/presentation/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PlanMateApp());
}

class PlanMateApp extends StatelessWidget {
  const PlanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
