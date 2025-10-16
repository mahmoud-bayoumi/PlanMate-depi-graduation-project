class Task {
  final String title;
  final String description;
  final bool status;

  Task({required this.title, required this.description, this.status = false});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      status: map['status'],
    );
  }
}
