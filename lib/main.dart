import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/authentication/bloc/auth_bloc.dart';
import 'features/authentication/bloc/auth_event.dart';
import 'features/authentication/bloc/auth_state.dart';
import 'features/home/data/services/user_event_service.dart';
import 'features/home/presentation/view_model/favourite_cubit/favourite_cubit.dart';
import 'features/home/presentation/view_model/get_category_cubit/get_category_cubit.dart';
import 'features/home/presentation/view_model/user_events_bloc/user_events_bloc.dart';
import 'features/home/presentation/view_model/user_events_bloc/user_events_event.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/profile/bloc/profile_event.dart';
import 'features/profile/services/profile_service.dart';
import 'features/splash/presentation/views/splash_view.dart';
import 'firebase_options.dart';
import 'features/authentication/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables and initialize Firebase
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PlanMateApp());
}

class PlanMateApp extends StatelessWidget {
  const PlanMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthService())..add(AuthStarted()),
        ),

        BlocProvider(
          create: (context) => GetCategoryCubit()..getCategories(),
        ),

        BlocProvider(
          create: (context) => FavoriteCubit()..fetchFavorites(),
        ),

        BlocProvider(
          create: (context) => UserEventsBloc(UserEventService()),
        ),

        BlocProvider(
          create: (context) => ProfileBloc(ProfileService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlanMate',
        theme: ThemeData(fontFamily: 'Poppins'),
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated && state.user != null) {
              Future.delayed(const Duration(milliseconds: 200), () {
                if (context.mounted) {
                  // Load user profile after successful authentication
                  context.read<ProfileBloc>().add(
                        LoadUserProfile(userId: state.user!.uid),
                      );
                }
              });
            }
          },
          child: const SplashView(),
        ),
      ),
    );
  }
}