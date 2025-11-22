import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class ToggleTodoUseCase {
  final TodoRepository repository;

  ToggleTodoUseCase(this.repository);

  Future<void> call(Todo todo) => repository.toggleTodo(todo);
}
