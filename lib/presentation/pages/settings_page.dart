import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/app_settings.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _usernameController = TextEditingController();
  final _tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pré-remplissage si les données sont déjà chargées
    final settings = context.read<SettingsProvider>().settings;
    if (settings?.username != null) {
      _usernameController.text = settings!.username!;
    }

    final token = context.read<AuthProvider>().token;
    if (token != null) {
      _tokenController.text = token;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final authProvider = context.watch<AuthProvider>();

    final settings = settingsProvider.settings;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'SharedPreferences = données non sensibles (UI, confort).\n'
              'Secure Storage = données sensibles (token, secrets).',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),

        // --- CONTAINER 1 : SHARED PREFERENCES (THEME + USERNAME) ---
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SharedPreferences',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Thème & username sauvegardés dans SharedPreferences',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),

              // --- Thème ---
              Text(
                'Theme',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              if (settings != null)
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('System'),
                      selected: settings.themeMode == AppThemeMode.system,
                      onSelected: (_) => settingsProvider
                          .changeTheme(AppThemeMode.system),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Light'),
                      selected: settings.themeMode == AppThemeMode.light,
                      onSelected: (_) =>
                          settingsProvider.changeTheme(AppThemeMode.light),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Dark'),
                      selected: settings.themeMode == AppThemeMode.dark,
                      onSelected: (_) =>
                          settingsProvider.changeTheme(AppThemeMode.dark),
                    ),
                  ],
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(),
                ),

              const SizedBox(height: 24),

              // --- Username ---
              Text(
                'Username',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final value = _usernameController.text.trim();
                      await settingsProvider.changeUsername(
                        value.isEmpty ? null : value,
                      );
                    },
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      _usernameController.clear();
                      await settingsProvider.changeUsername(null);
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Stored username: ${settings?.username ?? "(none)"}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // --- CONTAINER 2 : SECURE STORAGE (TOKEN) ---
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Secure Storage',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Token stocké dans FlutterSecureStorage',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Token',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final value = _tokenController.text.trim();
                      if (value.isNotEmpty) {
                        await authProvider.save(value);
                      }
                    },
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      await authProvider.clear();
                      _tokenController.clear();
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Stored token: ${authProvider.token ?? "(none)"}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

      ],
    );
  }
}
