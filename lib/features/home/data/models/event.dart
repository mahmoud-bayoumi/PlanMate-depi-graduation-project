import 'task.dart';

class EventModel {
  final String title;
  final String image;
  final String date;
  final String time;
  final String address;
  final String phone;
  final List<Task> tasks;

  EventModel({
    required this.title,
    required this.image,
    required this.date,
    required this.time,
    required this.address,
    required this.phone,
    required this.tasks,
  });

  // منMap آمن: يحوّل القيم ويعطي قيم افتراضية لو null
  factory EventModel.fromMap(Map<String, dynamic> map, List<Task> tasks) {
    return EventModel(
      title: (map['title'] as String?)?.toString() ?? '',
      image: (map['image'] as String?).toString(),
      date: (map['date'] as String?)?.toString() ?? '',
      time: (map['time'] as String?)?.toString() ?? '',
      address: (map['address'] as String?)?.toString() ?? '',
      phone: (map['phone'] as String?)?.toString() ?? '',
      tasks: tasks,
    );
  }
}