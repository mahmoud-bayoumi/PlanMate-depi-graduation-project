import 'package:flutter/material.dart';
import 'package:planmate_app/core/utils/constants.dart';
import 'package:planmate_app/features/favourites/presentation/view/favourite_view_body.dart';
import 'package:planmate_app/features/home/presentation/view/home_view_body.dart';
import 'package:planmate_app/features/home/presentation/view/widgets/icon_with_under_line.dart';
import 'package:planmate_app/features/profile/presentation/views/profile_view.dart';
import 'package:planmate_app/your_event_list_screen.dart';

class NavigateMainView extends StatefulWidget {
  const NavigateMainView({
    super.key,
  });

  @override
  State<NavigateMainView> createState() => _NavigateMainViewState();
}

class _NavigateMainViewState extends State<NavigateMainView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [
            HomeViewBody(),
            FavouriteViewBody(),
            EventsListScreen(),
            ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        selectedItemColor: Color(kPrimaryColor),
        unselectedItemColor: Color(0xff979C9E),
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
                ? IconWithUnderLine(
                    icon: Icon(
                      Icons.home_filled,
                      size: 28,
                    ),
                  )
                : Icon(
                    Icons.home_filled,
                    size: 28,
                  ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? IconWithUnderLine(
                    icon: Icon(
                      Icons.star_border_purple500_sharp,
                      size: 28,
                    ),
                  )
                : Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? IconWithUnderLine(
                    icon: Icon(
                      Icons.list_alt,
                      size: 28,
                    ),
                  )
                : Icon(Icons.list_alt),
            label: 'Event List',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? IconWithUnderLine(
                    icon: Icon(
                      Icons.person_pin,
                      size: 28,
                    ),
                  )
                : Icon(Icons.person_pin),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}