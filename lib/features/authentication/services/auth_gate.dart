import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../presentation/view/login_screen.dart';
import '../../navigation_bar/presentation/view/navigate_main_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show loading indicator while checking authentication state
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Navigate to main view if authenticated, else show login screen
        else if (state is AuthAuthenticated) {
          return const NavigateMainView();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}