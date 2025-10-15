import 'package:flutter/material.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Events List"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          _buildEventItem(
            title: "Electronic Steve - Music Festival",
            date: "10th February",
            address: "NICEL Ground, Bengaluru",
            time: "6:30 pm onwards",
            phone: "074063 88686",
            tasks: [
              {"title": "Book Tickets", "status": "uncompleted"},
              {"title": "Invite Friends", "status": "Completed"},
              {"title": "Arrange Transport", "status": "uncompleted"},
            ],
          ),
          _buildEventItem(
            title: "Birthday Party",
            date: "20th March",
            address: "ABC Hall, Bengaluru",
            time: "7:00 pm onwards",
            phone: "9876543210",
            tasks: [
              {"title": "Order Cake", "status": "Completed"},
              {"title": "Decorations", "status": "uncompleted"},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required String title,
    required String date,
    required String address,
    required String time,
    required String phone,
    required List<Map<String, String>> tasks,
  }) {
    return ExpansionTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.event, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date: $date"),
          Text("Address: $address"),
          Text("Time: $time"),
          Text("Phone: $phone"),
        ],
      ),
      children: tasks
          .map((task) => ListTile(
                title: Text(task["title"] ?? ""),
                subtitle: Text("Task Description"),
                trailing: Text(
                  task["status"] == "Completed"
                      ? "Completed"
                      : "Join Now",
                  style: TextStyle(
                    color: task["status"] == "Completed"
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
