import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/home/data/models/event.dart';
import 'features/home/data/services/user_event_service.dart';
import 'features/home/presentation/view_model/user_events_bloc/user_events_bloc.dart';
import 'features/home/presentation/view_model/user_events_bloc/user_events_event.dart';
import 'features/home/presentation/view_model/user_events_bloc/user_events_state.dart';
import 'your_event_list_screen.dart';
import 'package:share_plus/share_plus.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.eventModel});
  final EventModel eventModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: eventModel.image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventModel.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Free",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.share, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Date: ${eventModel.date}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Address: ${eventModel.address}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Time: ${eventModel.time}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Phone: ${eventModel.phone}",
                    style: const TextStyle(fontSize: 20),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Note :-",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text(
                    "You can access each event's tasks from the Events List screen.",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final bloc = context.read<UserEventsBloc>();
                    bloc.add(AddUserEvent(eventModel));

                    // Listen once for the result
                    final subscription = bloc.stream.listen((state) {
                      if (state is UserEventsError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      } else if (state is UserEventsLoaded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Event added to your list!"),
                          ),
                        );
                      }
                    });

                    // Auto-cancel after short delay
                    await Future.delayed(const Duration(seconds: 2));
                    await subscription.cancel();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Add To List",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
