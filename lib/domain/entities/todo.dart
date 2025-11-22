class Todo {
  final int? id;
  final String title;
  final bool isDone;

  const Todo({
    this.id,
    required this.title,
    required this.isDone,
  });

  Todo copyWith({int? id, String? title, bool? isDone}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
