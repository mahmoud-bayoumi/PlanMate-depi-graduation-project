import 'package:flutter/material.dart';

void main() {
  runApp(const PlanMateApp());
}

class PlanMateApp extends StatelessWidget {
  const PlanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('PlanMate')),
        body: const Center(child: Text('Welcome to PlanMate!')),
      ),
    );
  }
}
