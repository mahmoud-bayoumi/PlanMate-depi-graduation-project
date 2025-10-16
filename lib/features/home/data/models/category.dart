import 'event.dart';

class Category {
  final String id;
  final String name;
  final String image;
  final List<Event> events;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.events,
  });

  factory Category.fromMap(String id, Map<String, dynamic> map, List<Event> events) {
    return Category(
      id: id,
      name: map['name'],
      image: map['image'],
      events: events,
    );
  }
}
