import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Todo>> getTodos() async {
    final models = await localDataSource.getTodos();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTodo(String title) {
    return localDataSource.addTodo(title);
  }

  @override
  Future<void> toggleTodo(Todo todo) {
    if (todo.id == null) return Future.value();
    return localDataSource.toggleTodo(todo.id!, !todo.isDone);
  }
}
