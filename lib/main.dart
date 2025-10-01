import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planmate_app/bloc/auth_bloc.dart';
import 'package:planmate_app/bloc/auth_event.dart';
import 'package:planmate_app/bloc/auth_state.dart';
import 'package:planmate_app/screens/views/splash_screen.dart';
import 'package:planmate_app/services/auth_gate.dart';

void main() {
  runApp(const PlanMateApp());
}

class PlanMateApp extends StatelessWidget {
  const PlanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            context.read<AuthBloc>().add(AuthStarted());
            return SplashScreen();
          } else {
            return AuthGate();
          }
        },
      ),
    );
  }
}
