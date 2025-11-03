import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/data/models/event.dart';
import 'features/home/data/models/task.dart';
import 'features/home/presentation/view_model/user_events_bloc/user_events_bloc.dart';
import 'features/home/presentation/view_model/user_events_bloc/user_events_event.dart';
import 'features/home/presentation/view_model/user_events_bloc/user_events_state.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Events List"),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<UserEventsBloc, UserEventsState>(
        builder: (context, state) {
          if (state is UserEventsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserEventsError) {
            return Center(child: Text(" ${state.message}"));
          } else if (state is UserEventsLoaded) {
            final events = state.events;
            if (events.isEmpty) {
              return const Center(child: Text("No events added yet."));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserEventsBloc>().add(LoadUserEvents());
              },
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) =>
                    _buildEventItem(context, events[index]),
              ),
            );
          }
          return const Center(child: Text("No events to show."));
        },
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, EventModel event) {
    return ExpansionTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.event, color: Colors.white),
      ),
      title: Text(
        event.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date: ${event.date}"),
          Text("Address: ${event.address}"),
          Text("Time: ${event.time}"),
          Text("Phone: ${event.phone}"),
        ],
      ),
      children: event.tasks.isEmpty
          ? [const ListTile(title: Text("No tasks yet"))]
          : event.tasks
                .map((task) => _buildTaskItem(context, event, task))
                .toList(),
    );
  }

  Widget _buildTaskItem(BuildContext context, EventModel event, Task task) {
    return StatefulBuilder(
      builder: (context, setState) {
        // local stage state (0 = Join Now, 1 = Uncompleted, 2 = Completed)
        int stage = task.done ? 2 : 0;

        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: StatefulBuilder(
            builder: (context, localSetState) {
              return TextButton(
                onPressed: stage == 2
                    ? null
                    : () {
                        if (stage == 0) {
                          // first click — change to Uncompleted
                          localSetState(() => stage = 1);
                        } else if (stage == 1) {
                          // second click — mark completed & update Firestore
                          localSetState(() => stage = 2);

                          context.read<UserEventsBloc>().add(
                            MarkTaskDone(event.title, task.title),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "'${task.title}' marked as completed!",
                              ),
                            ),
                          );
                        }
                      },
                child: Text(
                  stage == 0
                      ? "Join Now"
                      : stage == 1
                      ? "Uncompleted"
                      : "Completed",
                  style: TextStyle(
                    color: stage == 2
                        ? Colors.green
                        : (stage == 1 ? Colors.red : Colors.red),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
