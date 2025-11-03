import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constants.dart';
import '../../../favourites/presentation/view/favourite_view_body.dart';
import '../../../home/presentation/view/home_view_body.dart';
import '../../../home/presentation/view/widgets/icon_with_under_line.dart';
import '../../../home/presentation/view_model/user_events_bloc/user_events_bloc.dart';
import '../../../home/presentation/view_model/user_events_bloc/user_events_event.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../../your_event_list_screen.dart';

class NavigateMainView extends StatefulWidget {
  const NavigateMainView({super.key});

  @override
  State<NavigateMainView> createState() => _NavigateMainViewState();
}

class _NavigateMainViewState extends State<NavigateMainView> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // 🔹 Automatically load user events when the main view starts
    // This ensures the "My Events" list is always up-to-date
    context.read<UserEventsBloc>().add(LoadUserEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: const [
            HomeViewBody(),
            FavouriteViewBody(),
            EventsListScreen(),
            ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        selectedItemColor: const Color(kPrimaryColor),
        unselectedItemColor: const Color(0xff979C9E),
        iconSize: 28,
        showSelectedLabels: false,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? const IconWithUnderLine(
                    icon: Icon(Icons.home_filled, size: 28),
                  )
                : const Icon(Icons.home_filled, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? const IconWithUnderLine(
                    icon: Icon(Icons.star_border_purple500_sharp, size: 28),
                  )
                : const Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? const IconWithUnderLine(icon: Icon(Icons.list_alt, size: 28))
                : const Icon(Icons.list_alt),
            label: 'Event List',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? const IconWithUnderLine(
                    icon: Icon(Icons.person_pin, size: 28),
                  )
                : const Icon(Icons.person_pin),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
