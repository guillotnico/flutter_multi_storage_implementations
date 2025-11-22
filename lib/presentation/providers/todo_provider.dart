import 'package:flutter/foundation.dart';

import '../../domain/entities/todo.dart';
import '../../domain/usecases/todo/add_todo.dart';
import '../../domain/usecases/todo/get_todos.dart';
import '../../domain/usecases/todo/toggle_todo.dart';

class TodoProvider extends ChangeNotifier {
  final GetTodosUseCase _getTodos;
  final AddTodoUseCase _addTodo;
  final ToggleTodoUseCase _toggleTodo;

  TodoProvider({
    required GetTodosUseCase getTodos,
    required AddTodoUseCase addTodo,
    required ToggleTodoUseCase toggleTodo,
  })  : _getTodos = getTodos,
        _addTodo = addTodo,
        _toggleTodo = toggleTodo;

  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTodos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todos = await _getTodos();
    } catch (e) {
      _error = 'Failed to load todos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    await _addTodo(title.trim());
    await loadTodos();
  }

  Future<void> toggle(Todo todo) async {
    await _toggleTodo(todo);
    await loadTodos();
  }
}
