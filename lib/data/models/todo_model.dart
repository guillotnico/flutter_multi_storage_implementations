import '../../domain/entities/todo.dart';
import '../../infrastructure/drift/app_database.dart';

class TodoModel {
  final int? id;
  final String title;
  final bool isDone;

  const TodoModel({
    this.id,
    required this.title,
    required this.isDone,
  });

  Todo toEntity() => Todo(id: id, title: title, isDone: isDone);

  factory TodoModel.fromEntity(Todo todo) => TodoModel(
    id: todo.id,
    title: todo.title,
    isDone: todo.isDone,
  );

  factory TodoModel.fromRow(TodoRow row) => TodoModel(
    id: row.id,
    title: row.title,
    isDone: row.isDone,
  );
}
