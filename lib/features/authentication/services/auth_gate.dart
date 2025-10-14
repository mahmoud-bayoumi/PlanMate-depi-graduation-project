import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planmate_app/features/authentication/bloc/auth_bloc.dart';
import 'package:planmate_app/features/authentication/bloc/auth_state.dart';
import 'package:planmate_app/features/authentication/presentation/view/login_screen.dart';
import 'package:planmate_app/features/navigation_bar/presentation/view/navigate_main_view.dart';

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
          return const NavigateMainView();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
