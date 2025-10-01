import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planmate_app/bloc/auth_bloc.dart';
import 'package:planmate_app/bloc/auth_state.dart';
import 'package:planmate_app/screens/views/home_screen.dart';
import 'package:planmate_app/screens/views/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthAuthenticated) {
          return HomeScreen();
        } else if (state is AuthUnauthenticated) {
          return LoginScreen();
        } else if (state is AuthError) {
          return Scaffold(body: Center(child: Text(state.errorMessage)));
        } else {
          return const Scaffold(body: Center(child: Text("Starting...")));
        }
      },
    );
  }
}
