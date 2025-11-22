import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/todo_provider.dart';
import 'settings_page.dart';
import 'todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // On garde juste le chargement des todos ici.
    // Settings et Auth sont déjà chargés dans MyApp via ..load()
    Future.microtask(() {
      context.read<TodoProvider>().loadTodos();
      context.read<AuthProvider>().load();
      // context.read<SettingsProvider>().load(); // plus nécessaire si tu le fais dans MyApp
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      TodoPage(),
      SettingsPage(),
    ];

    // On récupère les settings pour afficher le username
    final settingsProvider = context.watch<SettingsProvider>();
    final username = settingsProvider.settings?.username;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Multi-Storage Example'),
            if (username != null && username.isNotEmpty)
              Text(
                'Bonjour, $username',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[800]),
              ),
          ],
        ),
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: 'Todos',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
