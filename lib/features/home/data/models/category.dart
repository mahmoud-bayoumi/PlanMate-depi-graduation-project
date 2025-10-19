import 'event.dart';

class CategoryModel {
  final String name;
  final String image;
  final List<EventModel> events;

  CategoryModel({
    required this.name,
    required this.image,
    required this.events,
  });

  factory CategoryModel.fromMap(
    Map<String, dynamic> map,
    List<EventModel> events,
  ) {
    return CategoryModel(
      name: (map['name'] as String?)?.toString() ?? '',
      image: (map['image'] as String?)?.toString() ?? '',
      events: events,
    );
  }
}