import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/event.dart';
import '../../view_model/get_category_cubit/get_category_cubit.dart';
import 'event_item.dart';

class SliverListEventItem extends StatelessWidget {
  const SliverListEventItem({super.key});

  @override
  Widget build(BuildContext context) {
    List<EventModel> events = BlocProvider.of<GetCategoryCubit>(
      context,
    ).eventList;
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: events.length, (
        context,
        index,
      ) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
          child: EventItem(
            isFav: index == 0 ? true : false,
            eventModel: events[index],
          ),
        );
      }),
    );
  }
}
