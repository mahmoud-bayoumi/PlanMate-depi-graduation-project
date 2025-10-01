import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planmate_app/bloc/auth_bloc.dart';
import 'package:planmate_app/bloc/auth_state.dart';
import 'package:planmate_app/firebase_options.dart';
import 'package:planmate_app/screens/views/splash_screen.dart';
import 'package:planmate_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PlanMateApp());
}

class PlanMateApp extends StatelessWidget {
  const PlanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlanMate',
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SplashScreen();
          },
        ),
      ),
    );
  }
}
