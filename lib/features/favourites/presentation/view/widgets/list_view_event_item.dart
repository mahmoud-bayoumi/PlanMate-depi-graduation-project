import 'package:flutter/material.dart';
import '../../../../home/data/models/event.dart';
import '../../../../home/presentation/view/widgets/event_item.dart';

class ListViewEventItem extends StatelessWidget {
  const ListViewEventItem({super.key, required this.events});
  final List<EventModel> events;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 10, bottom: 20),
          child: EventItem(isFav: true, eventModel: events[index]),
        );
      },
    );
  }
}
