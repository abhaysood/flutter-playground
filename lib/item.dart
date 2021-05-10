class Task {
  final String id;
  final String title;
  final String description;

  Task({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class TasksStore {
  TasksStore._();

  static List<Task> tasks = List.generate(20, (index) {
    return Task(
      id: index.toString(),
      title: "Title $index",
      description: "Content",
    );
  });
}
