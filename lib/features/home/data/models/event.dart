import 'task.dart';

class Event {
  final String id;
  final String title;
  final String image;
  final String date;
  final String time;
  final String address;
  final String phone;
  final List<Task> tasks;

  Event({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.time,
    required this.address,
    required this.phone,
    required this.tasks,
  });

  factory Event.fromMap(String id, Map<String, dynamic> map, List<Task> tasks) {
    return Event(
      id: id,
      title: map['title'],
      image: map['image'],
      date: map['date'],
      time: map['time'],
      address: map['address'],
      phone: map['phone'],
      tasks: tasks,
    );
  }
}
