import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../widgets/todo_item_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'New todo',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) async {
                    await context.read<TodoProvider>().add(value);
                    _controller.clear();
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await context.read<TodoProvider>().add(_controller.text);
                  _controller.clear();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: provider.isLoading && provider.todos.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
            onRefresh: provider.loadTodos,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.todos.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final todo = provider.todos[index];
                return TodoItemTile(
                  todo: todo,
                  onToggle: () =>
                      context.read<TodoProvider>().toggle(todo),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
