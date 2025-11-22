import '../../infrastructure/drift/app_database.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> addTodo(String title);
  Future<void> toggleTodo(int id, bool newValue);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final AppDatabase db;

  TodoLocalDataSourceImpl({required this.db});

  @override
  Future<List<TodoModel>> getTodos() async {
    final rows = await db.getAllTodos();
    return rows.map(TodoModel.fromRow).toList();
  }

  @override
  Future<void> addTodo(String title) async {
    await db.insertTodo(title);
  }

  @override
  Future<void> toggleTodo(int id, bool newValue) async {
    await db.toggleTodo(id, newValue);
  }
}
