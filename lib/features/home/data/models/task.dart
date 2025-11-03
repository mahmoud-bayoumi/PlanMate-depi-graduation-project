class Task {
  final String title;
  final String description;
  final bool done;

  Task({
    required this.title,
    required this.description,
    required this.done,
  });

  // اسم الفاكتوري اختصرته لـ fromMap عشان يكون موحد وسهل الاستدعاء
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: (map['title'] as String?)?.toString() ?? '',
      description: (map['description'] as String?)?.toString() ?? '',
      done: (map['done'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'done': done,
    };
  }
}