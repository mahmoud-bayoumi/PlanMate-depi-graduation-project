import 'package:flutter/material.dart';
//<<<<<<< Updated upstream
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planmate_app/features/splash/presentation/views/splash_view.dart';
//=======
import 'package:planmate_app/event_details.dart';
import 'package:planmate_app/navigate_main_view.dart';
import 'package:planmate_app/your_event_list_screen.dart';
//>>>>>>> Stashed changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // <- make sure this runs
  runApp(const PlanMateApp());
}

class PlanMateApp extends StatelessWidget {
  const PlanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //<<<<<<< Updated upstream
      //debugShowCheckedModeBanner: false,
      //home: SplashView(),
      //=======
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const NavigateMainView(),
      //home: const EventsListScreen(),
      //>>>>>>> Stashed changes
    );
  }
}
