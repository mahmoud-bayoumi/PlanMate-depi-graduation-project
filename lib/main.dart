import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:planmate_app/bloc/auth_bloc.dart';
import 'package:planmate_app/bloc/auth_state.dart';
import 'package:planmate_app/firebase_options.dart';
import 'package:planmate_app/screens/views/splash_screen.dart';
import 'package:planmate_app/services/auth_service.dart';

import 'package:planmate_app/features/navigation_bar/presentation/view/navigate_main_view.dart';
// Optional additional imports (uncomment if needed):
// import 'package:planmate_app/event_details.dart';
// import 'package:planmate_app/your_event_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
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
        theme: ThemeData(fontFamily: 'Poppins'),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // You can change this to SplashScreen() or NavigateMainView()
            return const NavigateMainView(); // or SplashScreen()
          },
        ),
      ),
    );
  }
}
