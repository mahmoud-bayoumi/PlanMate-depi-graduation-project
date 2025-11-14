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
                .map((task) => _TaskItem(event: event, task: task))
                .toList(),
    );
  }
}

class _TaskItem extends StatefulWidget {
  final EventModel event;
  final Task task;

  const _TaskItem({required this.event, required this.task});

  @override
  State<_TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> {
  late int stage;

  @override
  void initState() {
    super.initState();
    // Initialize stage: 0 = Join Now, 1 = Uncompleted, 2 = Completed
    stage = widget.task.done ? 2 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.task.title),
      subtitle: Text(widget.task.description),
      trailing: TextButton(
        onPressed: stage == 2
            ? null
            : () {
                setState(() {
                  if (stage == 0) {
                    // First click —> change to Uncompleted
                    stage = 1;
                  } else if (stage == 1) {
                    // Second click —> mark completed & update Firestore
                    stage = 2;

                    context.read<UserEventsBloc>().add(
                      MarkTaskDone(widget.event.title, widget.task.title),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "'${widget.task.title}' marked as completed!",
                        ),
                      ),
                    );
                  }
                });
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
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}