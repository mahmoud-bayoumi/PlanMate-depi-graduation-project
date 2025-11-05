import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_links/app_links.dart';
import 'event_details.dart';
import 'features/authentication/bloc/auth_bloc.dart';
import 'features/authentication/bloc/auth_event.dart';
import 'features/authentication/bloc/auth_state.dart';
import 'features/home/data/models/event.dart';
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

class PlanMateApp extends StatefulWidget {
  const PlanMateApp({super.key});

  @override
  State<PlanMateApp> createState() => _PlanMateAppState();
}

class _PlanMateAppState extends State<PlanMateApp> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();

    // Initialize app links listener
    _appLinks = AppLinks();

    // Listen for deep links
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.pathSegments.isNotEmpty) {
        if (uri.pathSegments.first == 'event') {
          final eventTitle = Uri.decodeComponent(uri.pathSegments.last);

          // Example navigation (you can replace this with proper event fetching logic)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsScreen(
                eventModel: EventModel(
                  title: eventTitle,
                  image: '',
                  date: '',
                  time: '',
                  address: '',
                  phone: '',
                  tasks:
                      const [], 
                ),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthService())..add(AuthStarted()),
        ),
        BlocProvider(create: (context) => GetCategoryCubit()..getCategories()),
        BlocProvider(create: (context) => FavoriteCubit()..fetchFavorites()),
        BlocProvider(create: (context) => UserEventsBloc(UserEventService())),
        BlocProvider(create: (context) => ProfileBloc(ProfileService())),
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
