import 'package:flutter/material.dart';
import 'package:planmate_app/core/utils/constants.dart';
import 'package:planmate_app/event_details.dart';

class EventItem extends StatelessWidget {
  const EventItem({super.key, required this.isFav});
  final bool isFav;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return EventDetailsScreen();
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/event.jpg',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                FavouriteIcon(isFav: isFav),
              ],
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Laugh with Khalil Comedy / 20.12.2024",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "10:30 PM, Ali Baba Cafe, New Cairo",
                      style: TextStyle(
                        color: Color(0xff8D8D8D),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    "Free",
                    style: TextStyle(
                      color: Color(0xff6564DB),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({
    super.key,
    required this.isFav,
  });

  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            isFav ? Icons.star : Icons.star_border_purple500_sharp,
            color: Color(kPrimaryColor),
            size: 30,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
