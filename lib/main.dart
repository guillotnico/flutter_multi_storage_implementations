import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/settings_local_data_source.dart';
import 'data/datasources/todo_local_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/entities/app_settings.dart';
import 'domain/usecases/auth/clear_token.dart';
import 'domain/usecases/auth/get_token.dart';
import 'domain/usecases/auth/save_token.dart';
import 'domain/usecases/settings/get_settings.dart';
import 'domain/usecases/settings/update_theme.dart';
import 'domain/usecases/settings/update_username.dart';
import 'domain/usecases/todo/add_todo.dart';
import 'domain/usecases/todo/get_todos.dart';
import 'domain/usecases/todo/toggle_todo.dart';
import 'infrastructure/drift/app_database.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/todo_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Drift DB
  final db = AppDatabase();

  // Datasources
  final todoLocal = TodoLocalDataSourceImpl(db: db);
  final settingsLocal = SettingsLocalDataSourceImpl();
  final authLocal = AuthLocalDataSourceImpl();

  // Repositories
  final todoRepo = TodoRepositoryImpl(localDataSource: todoLocal);
  final settingsRepo =
  SettingsRepositoryImpl(localDataSource: settingsLocal);
  final authRepo = AuthRepositoryImpl(localDataSource: authLocal);

  // Use cases
  final getTodos = GetTodosUseCase(todoRepo);
  final addTodo = AddTodoUseCase(todoRepo);
  final toggleTodo = ToggleTodoUseCase(todoRepo);

  final getSettings = GetSettingsUseCase(settingsRepo);
  final updateTheme = UpdateThemeUseCase(settingsRepo);
  final updateUsername = UpdateUsernameUseCase(settingsRepo);

  final getToken = GetTokenUseCase(authRepo);
  final saveToken = SaveTokenUseCase(authRepo);
  final clearToken = ClearTokenUseCase(authRepo);

  runApp(MyApp(
    getTodos: getTodos,
    addTodo: addTodo,
    toggleTodo: toggleTodo,
    getSettings: getSettings,
    updateTheme: updateTheme,
    updateUsername: updateUsername,
    getToken: getToken,
    saveToken: saveToken,
    clearToken: clearToken,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.getTodos,
    required this.addTodo,
    required this.toggleTodo,
    required this.getSettings,
    required this.updateTheme,
    required this.updateUsername,
    required this.getToken,
    required this.saveToken,
    required this.clearToken,
  });

  final GetTodosUseCase getTodos;
  final AddTodoUseCase addTodo;
  final ToggleTodoUseCase toggleTodo;

  final GetSettingsUseCase getSettings;
  final UpdateThemeUseCase updateTheme;
  final UpdateUsernameUseCase updateUsername;

  final GetTokenUseCase getToken;
  final SaveTokenUseCase saveToken;
  final ClearTokenUseCase clearToken;

  ThemeMode _mapThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(
            getTodos: getTodos,
            addTodo: addTodo,
            toggleTodo: toggleTodo,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            getSettings: getSettings,
            updateTheme: updateTheme,
            updateUsername: updateUsername,
          )..load(), // 👈 charge les settings (SharedPreferences)
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            getToken: getToken,
            saveToken: saveToken,
            clearToken: clearToken,
          )..load(),
        ),
      ],
      // 👇 On écoute SettingsProvider pour piloter le thème
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          final settings = settingsProvider.settings;

          // Si pas encore chargé, on peut garder system par défaut
          final themeMode = _mapThemeMode(
            settings?.themeMode ?? AppThemeMode.system,
          );

          return MaterialApp(
            title: 'Multi-Storage Clean Architecture',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.dark,
            ),
            themeMode: themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

